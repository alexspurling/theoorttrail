module Game where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp
import Signal exposing (Address)

import Character.Player exposing (Player)

import Random exposing (Seed)

-- MODEL

type alias Model =
  { player : Player
  }

initialModel : Model
initialModel =
  { player = Character.Player.randomPlayer (Random.initialSeed 123)
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

main : Signal Html
main =
  StartApp.start
  { model = initialModel,
    view = view,
    update = update
  }
