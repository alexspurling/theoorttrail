module Game where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp
import Signal exposing (Address, (<~))
import Random
import Time
import Debug

import Character.Player exposing (Player)

port timestamp : Int

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


mainApp : StartApp.App Model Action
mainApp =
  { model = initialModel (Random.initialSeed timestamp),
    view = view,
    update = update
  }

main : Signal Html
main = StartApp.start (mainApp)

