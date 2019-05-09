module Main where

import Prelude

import HTMLHelloWorld (helloWorld)

import Data.Function.Uncurried (runFn2)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console as Console
import Elmish.React as React
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  mApp <- getElementById "app" =<< (map toNonElementParentNode <<< document) =<< window
  case mApp of
    Nothing ->
        Console.error "Can’t find #app element"
    Just app ->
        runFn2 React.reactMount app helloWorld
