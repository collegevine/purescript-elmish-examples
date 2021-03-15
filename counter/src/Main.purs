module Main where

import Prelude

import Counter as Counter
import CounterArray as CounterArray
import Data.Traversable (for)
import Effect (Effect)
import Effect.Aff (Aff)
import Elmish as Elmish
import Elmish.Boot as Boot
import Elmish.Component (ComponentReturnCallback)
import Frame as Frame
import ProgressReport as ProgressReport
import TwoCounters as TwoCounters

main :: Effect Unit
main = do
  items <- for examples \e -> do
    render <- e.create Elmish.construct
    pure { title: e.title, view: render }
  Boot.defaultMain { elementId: "app", def: Frame.frame items }

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
  , { title: "Reporting progress"
    , create: \f -> f ProgressReport.def
    }
  ]
