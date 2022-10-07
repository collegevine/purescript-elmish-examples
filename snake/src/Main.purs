module Main where

import Prelude

import Data.Array (findIndex, length, take, uncons, (..), (:))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Elmish (Dispatch, ReactElement, Transition)
import Elmish.Boot as Boot
import Elmish.HTML.Styled as H

type Cell = { x :: Int, y :: Int }
type State = Array Cell
data Message = Up | Down | Left | Right

bounds :: Cell
bounds = { x: 20, y: 20 }

init :: Transition Message State
init = pure $ (5..10) <#> \idx -> { x: idx, y: 10 }

view :: State -> Dispatch Message -> ReactElement
view state dispatch =
  H.div "m-4"
  [ H.div "d-flex flex-column mb-3" $ 0..(bounds.y-1) <#> \row ->
      H.div "d-flex" $ 0..(bounds.x-1) <#> \col ->
        H.div_ "border border-dark p-2 m-1" { style: H.css { background: bgColor col row } } ""
  , H.button_ "btn btn-outline-primary ml-5 mr-2" { onClick: dispatch Left } "⬅️"
  , H.button_ "btn btn-outline-primary mr-2" { onClick: dispatch Down } "⬇️"
  , H.button_ "btn btn-outline-primary mr-2" { onClick: dispatch Up } "⬆️"
  , H.button_ "btn btn-outline-primary mr-2" { onClick: dispatch Right } "➡️"
  ]
  where
    bgColor x y = case findIndex (eq { x, y }) state of
      Just idx -> "rgb(255, " <> show (idx*45) <> ", 255)"
      Nothing -> "white"

update :: State -> Message -> Transition Message State
update state msg = case msg of
  Up -> move 0 (-1)
  Down -> move 0 1
  Left -> move (-1) 0
  Right -> move 1 0
  where
    move dx dy = case uncons state of
      Just { head } -> do
        pure $ { x: head.x + dx, y: head.y + dy } : take (length state - 1) state
      Nothing ->
        pure state

main :: Effect Unit
main = Boot.defaultMain { elementId: "app", def: { init, view, update } }
