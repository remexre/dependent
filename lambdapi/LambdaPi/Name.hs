module LambdaPi.Name
  ( NamedTerm(..)
  , namedLamT
  ) where

import Data.String
  ( IsString(..)
  )

-- |An expression.
data NamedTerm
  = NamedTerm :$: NamedTerm
  | NamedTerm ::: NamedTerm
  | NHole
  | NLam String NamedTerm
  | NNat
  | NPi String NamedTerm NamedTerm
  | NSucc NamedTerm
  | NType
  | NVar String
  | NZero
  deriving Eq

instance IsString NamedTerm where
  fromString = NVar

instance Show NamedTerm where
  show (f :$: a) = "(" ++ show f ++ " " ++ show a ++ ")"
  show (te ::: ty) = "(" ++ show te ++ " : " ++ show ty ++ ")"
  show NHole = "_"
  show (NLam n b) = "(lambda " ++ n ++ ". " ++ show b ++ ")"
  show NNat = "Nat"
  show (NPi n k t) = "(pi<" ++ n ++ ": " ++ show k ++ ">. " ++ show t ++ ")"
  show v@(NSucc n) = maybe plain show (asNum v)
    where asNum NZero = Just 0
          asNum (NSucc v) = (1+) <$> asNum v
          asNum _ = Nothing
          plain = "(succ " ++ show n ++ ")"
  show NType = "*"
  show (NVar s) = s
  show NZero = "0"

namedLamT :: String -> NamedTerm -> NamedTerm -> NamedTerm
namedLamT arg ty body = (NLam arg body) ::: (NPi arg ty NHole)
