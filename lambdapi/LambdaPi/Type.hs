module LambdaPi.Type
  ( Typeck(..)
  , TypeEnv(..)
  , checkType
  , inferType
  , typeOf
  ) where

import LambdaPi.Eval
  ( eval
  , replace
  )
import LambdaPi.Lang
  ( Term(..)
  , quote
  )

data TypeEnv
  = TyNil
  | TyCons Term TypeEnv
  deriving (Eq, Show)

typeEnvGet :: TypeEnv -> Int -> Term
typeEnvGet TyNil _ = error "BUG: Got invalid term from TypeEnv"
typeEnvGet (TyCons h _) 0 = h
typeEnvGet (TyCons _ t) n = typeEnvGet t (n - 1)

-- |An error while typechecking.
data TypeError
  = Mismatch Term Term Term
  | NotInferable Term
  deriving Eq

instance Show TypeError where
   show (Mismatch t e g) = concat ["When checking the type of ", show t, ", expected ", show e,
                             ", found ", show g]
   show (NotInferable t) = "Can't infer the type of " ++ show t

checkType :: Term -> Term -> Typeck Term
checkType te@(Lam n b) ty@(Pi _ k t) = lamRule `orElse` inferRule te ty
  where lamRule = withEnv k $ checkType b t >>= return . Pi n k
checkType te ty = inferRule te ty

inferRule :: Term -> Term -> Typeck Term
inferRule te Hole = inferType te
inferRule te ty = inferType te >>= mustEq te ty >> return ty

inferType :: Term -> Typeck Term
inferType (App f a) = do
  fTy <- inferType f
  case fTy of
    Pi _ k t -> do
      checkType a k
      return . quote . eval . replace 0 (eval t) $ a
    _ -> throw $ Mismatch f fTy (Pi "" Hole Hole)
inferType Hole = return Type
inferType t@(Lam _ _) = throw $ NotInferable t
inferType Nat = return Type
inferType (Pi _ k t) = do
  checkType k Type
  withEnv (quote $ eval k) (checkType t Type)
  return Type
inferType (Succ t) = checkType t Nat >> return Nat
inferType (Ty te ty) = do
  checkType ty Type
  let tyNorm = quote $ eval ty
  checkType te tyNorm
inferType Type = return Type
inferType (Var n _) = var n
inferType Zero = return Nat

typeOf :: Term -> Either TypeError Term
typeOf = fmap fst . flip (runTypeck . inferType) TyNil

-- |Gets the variable at the given depth in the type environment.
var :: Int -> Typeck Term
var n = Typeck (\env -> Right (typeEnvGet env n, env))

-- |Fails with the given error.
throw :: TypeError -> Typeck a
throw = Typeck . const . Left

-- |If the latter two terms are not equal, fails with a Mismatch.
mustEq :: Term -> Term -> Term -> Typeck ()
mustEq t e g = if e == g then return () else throw $ Mismatch t e g

-- |If the first computation fails, runs the second instead.
orElse :: Typeck a -> Typeck a -> Typeck a
orElse l r = Typeck (\env -> case runTypeck l env of
                               Left _ -> runTypeck r env
                               Right x -> Right x)

-- |Adds a binding to the environment when running a subcomputation.
withEnv :: Term -> Typeck a -> Typeck a
withEnv e m = Typeck (runTypeck m . TyCons e)

-- |A monad used by the typechecker.
data Typeck a = Typeck { runTypeck :: TypeEnv -> Either TypeError (a, TypeEnv) }

instance Functor Typeck where
  fmap f x = Typeck (\env -> helper <$> runTypeck x env)
    where helper (x, env) = (f x, env)

instance Applicative Typeck where
  pure x = Typeck (\env -> Right (x, env))
  (<*>) f x = Typeck (\env -> runTypeck f env >>= helper)
    where helper (f', env) = (\(x', env') -> (f' x', env')) <$> runTypeck x env

instance Monad Typeck where
  (>>=) m f = Typeck (\env -> runTypeck m env >>= helper)
    where helper (x, env') = runTypeck (f x) env'
