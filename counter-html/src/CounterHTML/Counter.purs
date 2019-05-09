module CounterHTML.Counter( def, Message, State ) where

import Prelude
import Elmish (ComponentDef, Transition(..), handle, pureUpdate)
import Elmish.HTML as R

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

    view state dispatch =
      R.div {}
        [ R.h1 {}
          [ R.text "Counter ("
          , R.code {} "Elmish.HTML"
          , R.text ")"
          ]
        , R.text ("Count: " <> show state.count)
        , R.br {}
        , R.button { type: "button", onClick: handle dispatch Inc } "Inc"
        , R.button { type: "button", onClick: handle dispatch Dec } "Dec"
        ]
