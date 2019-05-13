module Main where

import Prelude

import Counter as Counter
import Data.Function.Uncurried (runFn2)
import Data.Maybe (Maybe(..))
import Data.Traversable (for)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Elmish (ComponentDef)
import Elmish as Elmish
import Elmish.React as React
import Frame as Frame
import TwoCounters as TwoCounters
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  el <- getElementById "app" =<< (map toNonElementParentNode <<< document) =<< window
  case el of
    Nothing ->
        log "Can't find #app element"
    Just e -> do
        items <- for examples mkItem
        runFn2 React.reactMount e =<< Elmish.construct (Frame.frame items) onError

  where
    onError = log

    mkItem :: Example -> Effect Frame.Item
    mkItem { title, create } = do
        view <- create \c -> Elmish.construct c onError
        pure { title, view }


type Example =
    { title :: String
    , create :: forall a. (forall m s. ComponentDef Aff m s -> Effect a) -> Effect a
    }

examples :: Array Example
examples =
    [ { title: "Simple counter", create: \f -> f Counter.def }
    , { title: "Two counters", create: \f -> f TwoCounters.def }
    ]
