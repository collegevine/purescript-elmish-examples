module Counter( def, Message, State ) where

import Prelude
import Elmish (ComponentDef, JsCallback0, ReactComponent, Transition(..), createElement', handle, pureUpdate)

data Message = Inc | Dec

type State = { count :: Int }

def :: forall m. ComponentDef m Message State
def =
  { init: Transition { count: 0 } []
  , update
  , view
  }
  where
    update s Inc = pureUpdate s { count = s.count+1 }
    update s Dec = pureUpdate s { count = s.count-1 }

    view s dispatch = createElement' view_
      { count: s.count
      , onInc: handle dispatch Inc
      , onDec: handle dispatch Dec
      }

foreign import view_ :: ReactComponent
  { count :: Int
  , onInc :: JsCallback0
  , onDec :: JsCallback0
  }
