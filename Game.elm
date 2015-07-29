module Game where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp
import Signal exposing (Address, (<~))
import Random
import Time

import Character.Player exposing (Player)

-- MODEL

type alias Model =
  { player : Player
  }

initialModel : Random.Seed -> Model
initialModel initialSeed =
  { player = Character.Player.randomPlayer initialSeed
  }

-- UPDATE

type Action =
  NoOp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

-- VIEw

eventsBox : Model -> Html
eventsBox model =
  textarea [ ] [ ]

view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
    [ Character.Player.view model.player,
      eventsBox model ]

-- WIRE IT ALL TOGETHER

seedSignal : Signal Random.Seed
seedSignal = (\ (t, _) -> Random.initialSeed <| round t) <~ Time.timestamp (Signal.constant ())

mainApp : Random.Seed -> StartApp.App Model Action
mainApp initialSeed =
  { model = initialModel initialSeed,
    view = view,
    update = update
  }

main : Signal Html
main =
  Signal.map (\seed -> StartApp.start (mainApp seed)) seedSignal
