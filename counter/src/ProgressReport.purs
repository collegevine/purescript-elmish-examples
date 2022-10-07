module ProgressReport( def, Message, State ) where

import Prelude

import Counter as Counter
import Data.Array ((..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Time.Duration (Milliseconds(..))
import Effect.Aff (delay)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Elmish (ComponentDef, bimap, forks, lmap)
import Elmish.HTML.Styled as H
import Elmish.React.DOM as R

data Message
  = CounterMsg Counter.Message
  | IncSlowlyStart
  | IncSlowlyProgress { percent :: Int }
  | IncSlowlyFinish

type State =
  { counter :: Counter.State
  , incSlowlyProgress :: Maybe { percent :: Int }
  }

def :: ComponentDef Message State
def =
  { init: do
      counter <- Counter.def.init # lmap CounterMsg
      pure { counter, incSlowlyProgress: Nothing }
  , update
  , view
  }
  where
    update s = case _ of
      CounterMsg m ->
        Counter.def.update s.counter m # bimap CounterMsg s { counter = _ }
      IncSlowlyStart -> do
        forks incSlowly
        pure s { incSlowlyProgress = Just { percent: 0 } }
      IncSlowlyProgress p ->
        pure s { incSlowlyProgress = Just p }
      IncSlowlyFinish ->
        pure s { incSlowlyProgress = Nothing }

    view s dispatch = R.fragment
      [ H.div "" $
          Counter.def.view s.counter (dispatch <<< CounterMsg)
      , H.div "" $ case s.incSlowlyProgress of
          Nothing ->
            H.button_ "btn btn-primary"
              { onClick: dispatch IncSlowlyStart }
              "Inc Slowly"
          Just { percent } ->
            H.div "progress" $
              H.div_ "progress-bar"
                { style: H.css { width: show percent <> "%" } }
                ""
      ]

    incSlowly dispatch = liftAff do
      for_ (0..20) \n -> do
        delay $ Milliseconds 100.0
        d $ IncSlowlyProgress { percent: n*5 }
      delay $ Milliseconds 400.0
      d $ CounterMsg Counter.Inc
      d IncSlowlyFinish
      where
        d = liftEffect <<< dispatch
