module Frame
  ( Item
  , Message
  , State
  , frame
  ) where

import Prelude

import Data.Array (head, mapWithIndex, (!!))
import Data.Maybe (Maybe, maybe)
import Effect.Aff (Aff)
import Elmish (ComponentDef, ReactElement)
import Elmish.HTML.Styled as H
import Elmish.React.DOM as R

type Item =
    { title :: String
    , view :: ReactElement
    }

type State =
    { selectedIndex :: Int
    , selectedItem :: Maybe Item
    }

data Message = SelectIndex Int

frame :: Array Item -> ComponentDef Aff Message State
frame items =
  { init: pure
    { selectedIndex: 0
    , selectedItem: head items
    }
  , update: \s (SelectIndex idx) -> pure
    { selectedIndex: idx
    , selectedItem: items !! idx
    }
  , view: \s dispatch ->
      H.div "container mt-4" $
        H.div "row"
        [ H.div "col-3" $
            H.div "list-group" $
              items # mapWithIndex \idx item ->
                H.div_ ("list-group-item " <> if idx == s.selectedIndex then "active" else "")
                  { onClick: dispatch $ SelectIndex idx }
                  item.title
        , H.div "col-9" $
            H.div "card" $
              H.div "card-body" $
                maybe R.empty _.view s.selectedItem
        ]
  }
