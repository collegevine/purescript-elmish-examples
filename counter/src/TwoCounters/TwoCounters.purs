module TwoCounters( def, Message, State ) where

import Prelude

import Counter as Counter
import Data.Functor.Contravariant ((>#<))
import Elmish (ComponentDef, ReactComponent, ReactElement, Transition(..), createElement', (<$$>))

data Message
    = OneMsg Counter.Message
    | TwoMsg Counter.Message

type State =
    { one :: Counter.State
    , two :: Counter.State
    }

def :: forall m. Monad m => ComponentDef m Message State
def =
  { init: Transition { one: s, two: s } $ (OneMsg <$$> cmds) <> (TwoMsg <$$> cmds)
  , update
  , view
  }
  where
    Transition s cmds = Counter.def.init

    update s (OneMsg m) =
        let Transition s' cmds = Counter.def.update s.one m
        in Transition s { one = s' } (OneMsg <$$> cmds)
    update s (TwoMsg m) =
        let Transition s' cmds = Counter.def.update s.two m
        in Transition s { two = s' } (TwoMsg <$$> cmds)

    view s dispatch = createElement' view_
      { one: Counter.def.view s.one $ dispatch >#< OneMsg
      , two: Counter.def.view s.two $ dispatch >#< TwoMsg
      }

foreign import view_ :: ReactComponent
  { one :: ReactElement
  , two :: ReactElement
  }
