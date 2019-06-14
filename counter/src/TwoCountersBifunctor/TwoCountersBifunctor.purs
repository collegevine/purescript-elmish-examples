module TwoCountersBifunctor( def, Message, State ) where

import Prelude

import Counter as Counter
import Data.Bifunctor (lmap)
import Data.Functor.Contravariant ((>#<))
import Elmish (ComponentDef, ReactComponent, ReactElement, createElement')

data Message
    = OneMsg Counter.Message
    | TwoMsg Counter.Message

type State =
    { one :: Counter.State
    , two :: Counter.State
    }

def :: forall m. Monad m => ComponentDef m Message State
def = { init, update, view }
  where
    init = { one: _, two: _ }
        <$> lmap OneMsg Counter.def.init
        <*> lmap TwoMsg Counter.def.init

    update s (OneMsg m) =
        s { one = _ } <$> lmap OneMsg (Counter.def.update s.one m)
    update s (TwoMsg m) =
        s { two = _ } <$> lmap TwoMsg (Counter.def.update s.two m)

    view s dispatch = createElement' view_
      { one: Counter.def.view s.one $ dispatch >#< OneMsg
      , two: Counter.def.view s.two $ dispatch >#< TwoMsg
      }

foreign import view_ :: ReactComponent
  { one :: ReactElement
  , two :: ReactElement
  }
