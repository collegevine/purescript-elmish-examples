module Main where

import Prelude

import Effect (Effect)
import Elmish.Boot (defaultMain)
import HTMLHelloWorld (helloWorld)

main :: Effect Unit
main = defaultMain
    { elementId: "app"
    , def:
        { init: pure unit
        , update: \_ _ -> pure unit
        , view: \_ _ -> helloWorld
        }
    }
