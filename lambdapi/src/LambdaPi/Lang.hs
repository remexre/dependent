module LambdaPi.Lang
  ( Stuck(..)
  , Term(..)
  , Value(..)
  , name
  , quote
  , unname
  ) where

import Data.List
  ( elemIndex
  )
import Data.Maybe
  ( fromMaybe
  )
import LambdaPi.Name
  ( NamedTerm(..)
  )

-- |An expression.
data Term
  = App Term Term
  | Hole
  | Lam String Term
  | Nat
  | Pi String Term Term
  | Succ Term
  | Ty Term Term
  | Type
  | Var Int String
  | Zero
  deriving Eq

instance Show Term where
  show = show . flip name []

name :: Term -> [String] -> NamedTerm
name (App f a) e = name f e :$: name a e
name (Ty te ty) e = name te e ::: name ty e
name Hole _ = NHole
name (Lam "" b) e = NLam n (name b (n:e))
  where n = "$" ++ (show $ length e)
name (Lam n b) e = NLam n (name b (n:e))
name Nat _ = NNat
name (Pi "" k t) e = NPi n (name k e) (name t (n:e))
  where n = "$" ++ (show $ length e)
name (Pi n k t) e = NPi n (name k e) (name t (n:e))
name (Succ n) e = NSucc (name n e)
name Type _ = NType
name (Var n "") e = NVar (e !! n)
name (Var _ na) _ = NVar na
name Zero _ = NZero

unname :: NamedTerm -> [String] -> Term
unname (f :$: a) e = App (unname f e) (unname a e)
unname (te ::: ty) e = Ty (unname te e) (unname ty e)
unname NHole _ = Hole
unname (NLam n b) e = Lam n (unname b (n:e))
unname NNat _ = Nat
unname (NPi n k t) e = Pi n (unname k e) (unname t (n:e))
unname (NSucc n) e = Succ (unname n e)
unname NType _ = Type
unname (NVar n) e = Var (fromMaybe err $ elemIndex n e) n
  where err = error $ "Unbound name: " ++ n
unname NZero _ = Zero

quote :: Value -> Term
quote VHole = Hole
quote (VLam n b) = Lam n $ quote b
quote VNat = Nat
quote (VStuck (SApp f a)) = App (quote (VStuck f)) (quote a)
quote (VStuck (SVar n na)) = Var n na
quote (VPi n k t) = Pi n (quote k) (quote t)
quote (VSucc n) = Succ $ quote n
quote VType = Type
quote VZero = Zero

-- |A value.
data Value
  = VHole
  | VLam String Value
  | VNat
  | VStuck Stuck
  | VPi String Value Value
  | VSucc Value
  | VType
  | VZero
  deriving Eq

instance Show Value where
  show = show . quote

-- |A variable or a "stuck" application.
data Stuck
  = SApp Stuck Value
  | SVar Int String
  deriving Eq

instance Show Stuck where
  show = show . VStuck
