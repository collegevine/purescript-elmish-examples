module Main where

import Prelude

import Effect (Effect)
import Elmish (boot)
import HTMLHelloWorld (helloWorld)

main :: Effect Unit
main = boot
    { domElementId: "app"
    , def:
        { init: pure unit
        , update: \_ _ -> pure unit
        , view: \_ _ -> helloWorld
        }
    }
