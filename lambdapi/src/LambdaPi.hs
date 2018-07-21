module LambdaPi
  ( NamedTerm(..)
  , Stuck(..)
  , Term(..)
  , Typeck(..)
  , TypeEnv(..)
  , Value(..)
  , checkType
  , eval
  , inferType
  , name
  , namedLamT
  , quote
  , typeOf
  , unname
  ) where

import LambdaPi.Eval
  ( eval
  )
import LambdaPi.Lang
  ( Stuck(..)
  , Term(..)
  , Value(..)
  , name
  , quote
  , unname
  )
import LambdaPi.Name
  ( NamedTerm(..)
  , namedLamT
  )
import LambdaPi.Type
  ( Typeck(..)
  , TypeEnv(..)
  , checkType
  , inferType
  , typeOf
  )
