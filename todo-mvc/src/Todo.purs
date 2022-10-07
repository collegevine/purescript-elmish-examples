module Todo
  ( Filter
  , Message
  , State
  , Todo
  , def
  ) where

import Prelude

import Data.Array as Array
import Data.Foldable (for_)
import Data.Maybe (Maybe(..), fromMaybe)
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Elmish (ComponentDef, Dispatch, ReactElement, Transition, fork, forkVoid, forks, handle, handleMaybe, (<?|), (<|))
import Elmish.Foreign (Foreign, readForeign)
import Elmish.HTML.Styled as H
import Elmish.React.DOM as R
import Foreign.Object as Obj
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.HashChangeEvent.EventTypes (hashchange)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.HTMLElement (focus, fromElement)
import Web.HTML.Location (hash, setHash)
import Web.HTML.Window (document, location, toEventTarget)

def :: ComponentDef Message State
def = { init, update, view }

data Message
  = CreateNew
  | NewNameChanged String
  | StartEdit { index :: Int }
  | CommitEdit
  | CancelEdit
  | Edit String
  | Delete { index :: Int }
  | Toggle { index :: Int }
  | ToggleAll Boolean
  | SetFilter Filter

type State =
  { newTodoName :: String
  , editing :: Maybe { index :: Int, name :: String }
  , filter :: Filter
  , todos :: Array Todo
  }

type Todo =
  { name :: String
  , checked :: Boolean
  }

data Filter = All | Checked | Unchecked
derive instance eqFilter :: Eq Filter

init :: Transition Message State
init = do
  fork $ liftEffect readRoute
  forks watchRoute
  pure
    { newTodoName: ""
    , editing: Nothing
    , filter: All
    , todos: []
    }

update :: State -> Message -> Transition Message State
update state = case _ of
  CreateNew ->
    pure state
      { todos = Array.snoc state.todos { name: state.newTodoName, checked: false }
      , newTodoName = ""
      }

  NewNameChanged name ->
    pure state { newTodoName = name }

  StartEdit { index } | Just { name } <- Array.index state.todos index -> do
    forkVoid $ liftAff do
      delay $ Milliseconds 10.0
      mEl <- liftEffect $ window >>= document <#> toNonElementParentNode >>= getElementById ("edit-" <> show index)
      for_ (fromElement =<< mEl) $ liftEffect <<< focus
    pure state { editing = Just { index, name } }
  StartEdit _ ->
    pure state

  CommitEdit
    | Just { index, name: "" } <- state.editing -> do
        fork $ pure $ Delete { index }
        pure state
    | Just e <- state.editing ->
        pure state
          { editing = Nothing
          , todos =
              state.todos
              # Array.modifyAt e.index _ { name = e.name }
              # fromMaybe state.todos
          }
    | otherwise ->
        pure state

  CancelEdit ->
    pure state { editing = Nothing }

  Edit name | Just e <- state.editing ->
    pure state { editing = Just e { name = name } }
  Edit _ ->
    pure state

  Delete { index } ->
    pure state
      { todos = state.todos # Array.deleteAt index # fromMaybe state.todos
      }

  Toggle { index } ->
    pure state
      { todos =
          state.todos
          # Array.modifyAt index (\t -> t { checked = not t.checked })
          # fromMaybe state.todos
      }

  ToggleAll checked ->
    pure state
      { todos = state.todos <#> \t -> t { checked = checked }
      }

  SetFilter f -> do
    forkVoid $ liftEffect $ setRoute f
    pure state { filter = f }

view :: State -> Dispatch Message -> ReactElement
view state dispatch = R.fragment [header, body, footer]
  where
    header =
      H.header "header"
      [ H.h1 "" "todos"
      , H.input_ "new-todo"
          { type: "text"
          , value: state.newTodoName
          , onChange: handleMaybe dispatch \e -> NewNameChanged <$> eventTargetValue e
          , onKeyPress: handleMaybe dispatch \e -> if eventKey e == Just "Enter" then Just CreateNew else Nothing
          , placeholder: "What needs to be done?"
          , autoFocus: true
          }
      ]

    body =
      H.section "main"
      [ H.input_ "toggle-all"
          { id: "toggle-all"
          , type: "checkbox"
          , checked: allChecked
          , onChange: handle dispatch \_ -> ToggleAll $ not allChecked
          }
      , H.label_ "" { htmlFor: "toggle-all" } "Mark all as complete"

      , H.ul "todo-list" $
          state.todos
          # Array.filter filter
          # Array.mapWithIndex \idx t ->
            todo { t, index: idx, editing: Just idx == (state.editing <#> _.index) }
      ]

    footer =
      H.footer "footer"
      [ H.span "todo-count"
        [ H.strong "" $ show uncheckedCount
        , R.text " items left"
        ]
      , H.ul "filters" $
          [All, Unchecked, Checked] <#> \f ->
            H.li "" $
              H.a_ (if f == state.filter then "selected" else "")
                { href: "#/" <> filterRoute f
                , onClick: dispatch $ SetFilter f
                } $
                filterName f
      ]

    todo { t, index, editing } =
      H.li cls
      [ H.div "view"
        [ H.input_ "toggle"
            { type: "checkbox"
            , checked: t.checked
            , onChange: dispatch <| \_ -> Toggle { index }
            }
        , H.label_ ""
            { onDoubleClick: dispatch $ StartEdit { index } }
            t.name
        , H.button_ "destroy" { onClick: dispatch $ Delete { index } } ""
        ]
      , H.input_ "edit"
          { id: "edit-" <> show index
          , type: "text"
          , value: state.editing <#> _.name # fromMaybe ""
          , onBlur: dispatch CancelEdit
          , onChange: dispatch <?| \e -> Edit <$> eventTargetValue e
          , onKeyDown: dispatch <?| \e ->
              case eventKey e of
                Just "Enter" -> Just CommitEdit
                Just "Escape" -> Just CancelEdit
                _ -> Nothing
          }
      ]
      where
        cls =
          if t.checked then "completed" else ""
          <> if editing then " editing" else ""

    allChecked = state.todos # Array.all _.checked
    uncheckedCount = state.todos # Array.filter (not _.checked) # Array.length

    filter = case state.filter of
      All -> const true
      Checked -> _.checked
      Unchecked -> not _.checked

    filterName = case _ of
      All -> "All"
      Checked -> "Completed"
      Unchecked -> "Active"

filterRoute :: Filter -> String
filterRoute = case _ of
  All -> "all"
  Checked -> "completed"
  Unchecked -> "active"

watchRoute :: (Message -> Effect Unit) -> Aff Unit
watchRoute dispatch = liftEffect do
  listener <- eventListener \_ -> readRoute >>= dispatch
  target <- toEventTarget <$> window
  addEventListener hashchange listener false target

readRoute :: Effect Message
readRoute = do
  h <- window >>= location >>= hash
  pure $
    [All, Checked, Unchecked]
    # Array.find (\f -> ("#/" <> filterRoute f) == h)
    # fromMaybe All
    # SetFilter

setRoute :: Filter -> Effect Unit
setRoute f =
  window >>= location >>= setHash ("/" <> filterRoute f)

eventTargetValue :: Foreign -> Maybe String
eventTargetValue =
  readForeign
  >=> Obj.lookup "target" >=> readForeign
  >=> Obj.lookup "value" >=> readForeign

eventKey :: Foreign -> Maybe String
eventKey =
  readForeign
  >=> Obj.lookup "key" >=> readForeign
