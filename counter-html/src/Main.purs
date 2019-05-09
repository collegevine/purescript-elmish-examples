module Main where

import Prelude

import CounterHTML.Counter as Counter
import Data.Function.Uncurried (runFn2)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Elmish as Elmish
import Elmish.React as React
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  el <- getElementById "app" =<< (map toNonElementParentNode <<< document) =<< window
  case el of
    Nothing -> log "Can’t find #app element"
    Just e -> runFn2 React.reactMount e =<< Elmish.construct Counter.def onError

  where
    onError = log
