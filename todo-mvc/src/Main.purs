module Main where

import Prelude

import Effect (Effect)
import Elmish.Boot (defaultMain)
import Todo (def)

main :: Effect Unit
main = defaultMain { elementId: "app", def }
