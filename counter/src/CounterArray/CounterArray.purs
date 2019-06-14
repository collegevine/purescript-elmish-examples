module CounterArray( def, Message, State ) where

import Prelude

import Counter as Counter
import Data.Array (mapWithIndex, updateAt, (!!), (..))
import Data.Bifunctor (lmap)
import Data.Functor.Contravariant ((>#<))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Traversable (sequence)
import Elmish (ComponentDef, ReactComponent, ReactElement, createElement')

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
            pure $ lmap (ChildMsg idx) Counter.def.init

        update children (ChildMsg idx m) =
            case children !! idx of
                Just childS -> ado
                    newChildS <- lmap (ChildMsg idx) $ Counter.def.update childS m
                    in fromMaybe children $ updateAt idx newChildS children
                Nothing ->
                    pure children

        view children dispatch = createElement' view_
            { counters: mapWithIndex renderChild children
            }
            where
                renderChild idx childS =
                    Counter.def.view childS $ dispatch >#< (ChildMsg idx)

foreign import view_ :: ReactComponent
  { counters :: Array ReactElement
  }
