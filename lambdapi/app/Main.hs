module Main
  ( main
  ) where

import LambdaPi
  ( Term(Hole)
  , NamedTerm(..)
  , Value
  , eval
  , name
  , namedLamT
  , typeOf
  , unname
  )

s :: NamedTerm
s = namedLamT "xTy" NType $ namedLamT "yTy" NType $ namedLamT "zTy" NType
  $ namedLamT "x" "xTy" $ namedLamT "y" "yTy" $ namedLamT "z" "zTy"
  $ ("x" :$: "z") :$: ("y" :$: "z")

k :: NamedTerm
k = namedLamT "xTy" NType
  $ namedLamT "yTy" NType
  $ namedLamT "x" "xTy"
  $ namedLamT "y" "yTy"
  $ "x"

i :: NamedTerm
i = namedLamT "xTy" NType
  $ namedLamT "x" "xTy"
  $ "x"

main :: IO ()
main = do
  undefined

evalWith :: [(String, NamedTerm)] -> NamedTerm -> Value
evalWith env = eval . flip unname [] . wrap env

wrap :: [(String, NamedTerm)] -> NamedTerm -> NamedTerm
wrap env term = foldr helper term env
  where helper (n, v) term = namedLamT n (typeOfNamed v) term :$: v
        orHole (Left _) = Hole
        orHole (Right ty) = ty
        typeOfNamed = flip name [] . orHole . typeOf . flip unname []
