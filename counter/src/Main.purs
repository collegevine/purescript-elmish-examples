module Main where

import Prelude

import Counter as Counter
import CounterArray as CounterArray
import Data.Traversable (for)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Elmish as Elmish
import Elmish.Component (ComponentReturnCallback)
import Elmish.Dispatch (dispatchMsgFn)
import Frame as Frame
import TwoCounters as TwoCounters

main :: Effect Unit
main = do
  items <- for examples \e -> do
    render <- e.create Elmish.construct
    pure { title: e.title, view: render onError }
  (Elmish.boot \_ -> Frame.frame items).mount "app" {}
  where
    onError = dispatchMsgFn log (const $ pure unit)


type Example =
  { title :: String
  , create :: forall a. ComponentReturnCallback Aff (Effect a) -> Effect a
  }

examples :: Array Example
examples =
  [ { title: "Simple counter"
    , create: \f -> f Counter.def
    }
  , { title: "Two counters"
    , create: \f -> f TwoCounters.def
    }
  , { title: "Array of counters"
    , create: \f -> f CounterArray.def
    }
  ]
