module Frame
    ( Item
    , State
    , frame
    ) where

import Prelude

import Data.Array (head, mapWithIndex, (!!))
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect.Aff (Aff)
import Elmish (ComponentDef, ReactComponent, ReactElement, Transition(..), JsCallback0, createElement', handle, pureUpdate)

type Item =
    { title :: String
    , view :: ReactElement
    }

type State =
    { selectedIndex :: Int
    , selectedItem :: Maybe Item
    }

type Message = Int

frame :: Array Item -> ComponentDef Aff Message State
frame items =
    { init: Transition initState []
    , update: \s idx -> pureUpdate
        { selectedIndex: idx
        , selectedItem: items !! idx
        }
    , view: \s dispatch -> createElement' view_
        { items: itemView dispatch s.selectedIndex `mapWithIndex` items
        , inner: toNullable $ _.view <$> s.selectedItem
        }
    }
    where
        initState =
            { selectedIndex: 0
            , selectedItem: head items
            }

        itemView dispatch selectedIdx idx i =
            { title: i.title
            , isSelected: idx == selectedIdx
            , onSelect: handle dispatch idx
            }

foreign import view_ :: ReactComponent
    { items :: Array { title :: String, isSelected :: Boolean, onSelect :: JsCallback0 }
    , inner :: Nullable ReactElement
    }
