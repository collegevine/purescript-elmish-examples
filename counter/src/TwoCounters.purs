module TwoCounters( def, Message, State ) where

import Prelude

import Counter as Counter
import Elmish (ComponentDef, bimap, lmap)
import Elmish.HTML.Styled as H

data Message
  = OneMsg Counter.Message
  | TwoMsg Counter.Message

type State =
  { one :: Counter.State
  , two :: Counter.State
  }

def :: ComponentDef Message State
def =
  { init: do
      one <- Counter.def.init # lmap OneMsg
      two <- Counter.def.init # lmap TwoMsg
      pure { one, two }
  , update
  , view
  }
  where
    update s (OneMsg m) =
      Counter.def.update s.one m # bimap OneMsg s { one = _ }
    update s (TwoMsg m) =
      Counter.def.update s.two m # bimap TwoMsg s { two = _ }

    view s dispatch =
      H.div "row"
      [ H.div "col-6" $ Counter.def.view s.one (dispatch <<< OneMsg)
      , H.div "col-6" $ Counter.def.view s.two (dispatch <<< TwoMsg)
      ]
