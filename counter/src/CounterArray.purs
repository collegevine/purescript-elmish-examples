module CounterArray( def, Message, State ) where

import Prelude

import Counter as Counter
import Data.Array (mapWithIndex, updateAt, (!!), (..))
import Data.Bifunctor (lmap)
import Data.Functor.Contravariant ((>#<))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Traversable (sequence)
import Elmish (ComponentDef)
import Elmish.HTML.Styled as H
import Elmish.React.DOM as R

type Index = Int

data Message
  = ChildMsg Index Counter.Message

type State =
  Array Counter.State

def :: forall m. Monad m => ComponentDef m Message State
def = { init, update, view }
  where
    init = sequence do
      idx <- 1..5
      pure $ Counter.def.init # lmap (ChildMsg idx)

    update children (ChildMsg idx m) =
      case children !! idx of
        Just childS -> do
          newChildS <- Counter.def.update childS m # lmap (ChildMsg idx)
          pure $ fromMaybe children $ updateAt idx newChildS children
        Nothing ->
          pure children

    view children dispatch = R.fragment $
      children # mapWithIndex \idx childS ->
        H.div_ "row mb-3" { key: show idx }
        [ H.div "col-1" $ show (idx + 1)
        , H.div "col-10" $
            Counter.def.view childS (dispatch >#< ChildMsg idx)
        ]
