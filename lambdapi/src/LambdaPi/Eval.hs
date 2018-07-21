module LambdaPi.Eval
  ( eval
  , replace
  ) where

import LambdaPi.Lang
  ( Stuck(..)
  , Term(..)
  , Value(..)
  , quote
  )

eval :: Term -> Value
eval (App f a) = helper (eval f) (eval a)
  where helper (VStuck n) = VStuck . SApp n
        helper (VLam _ b) = eval . shift (-1) 0 . replace 0 b . shift 1 0 . quote
        helper v = error $ "Not callable: " ++ show v
eval Hole = VHole
eval (Lam n b) = VLam n $ eval b
eval Nat = VNat
eval (Pi n k t) = VPi n (eval k) (eval t)
eval (Succ n) = VSucc $ eval n
eval (Ty term _) = eval term
eval Type = VType
eval (Var n na) = VStuck $ SVar n na
eval Zero = VZero

replace :: Int -> Value -> Term -> Term
replace _ VHole _ = Hole -- TODO: What are the right semantics here?
replace v (VLam n b) r = Lam n (replace (v+1) b r)
replace _ VNat _ = Nat
replace v (VStuck (SApp f a)) r = App (replace v (VStuck f) r) (replace v a r)
replace v (VStuck (SVar n na)) r = if v == n then r else Var n na
replace v (VPi n k t) r = Pi n (replace v k r) (replace (v+1) t r)
replace v (VSucc n) r = Succ $ replace v n r
replace _ VType _ = Type
replace _ VZero _ = Zero

shift :: Int -> Int -> Term -> Term
shift d c (App f a) = App (shift d c f) (shift d c a)
shift _ _ Hole = Hole -- TODO: What are the right semantics here?
shift d c (Lam n b) = Lam n $ shift d (c+1) b
shift _ _ Nat = Nat
shift d c (Pi n k t) = Pi n (shift d c k) (shift d (c+1) t)
shift d c (Succ m) = Succ $ shift d c m
shift d c (Ty tr ty) = Ty (shift d c tr) (shift d c ty)
shift _ _ Type = Type
shift d c (Var n na) = Var (if n >= c then n + d else n) na
shift _ _ Zero = Zero
