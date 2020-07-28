module Counter( def, Message, State ) where

import Prelude

import Elmish (ComponentDef, handle)
import Elmish.HTML.Styled as H

data Message = Inc | Dec

type State = { count :: Int }

def :: forall m. ComponentDef m Message State
def =
  { init: pure { count: 0 }
  , update
  , view
  }
  where
    update s Inc = pure s { count = s.count+1 }
    update s Dec = pure s { count = s.count-1 }

    view s dispatch =
      H.div "row"
      [ H.div "col-3"
        [ H.div "" "Count"
        , H.h2 "" $ show s.count
        ]
      , H.div "col-3"
        [ H.button_ "btn btn-primary mr-2" { onClick: handle dispatch Inc } "Inc"
        , H.button_ "btn btn-primary" { onClick: handle dispatch Dec } "Dec"
        ]
      ]
