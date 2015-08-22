module Game where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Array exposing (Array)
import StartApp
import Signal exposing (Address, (<~))
import Random
import Time
import Debug

import Character.Player exposing (Player)
import Location.Planet exposing (Planet)
import Location.Galaxy exposing (Galaxy)

import Native.Now

-- MODEL

type alias Model =
  { player : Player,
    galaxy : Galaxy,
    location : Planet
  }

initialModel : Random.Seed -> Model
initialModel initialSeed =
  let
    newGalaxy = Location.Galaxy.newGalaxy initialSeed
    startingPlanet = Location.Galaxy.startingPlanet newGalaxy
  in
  { player = Character.Player.randomPlayer initialSeed,
    galaxy = newGalaxy,
    location = startingPlanet
  }

-- UPDATE

type Action =
  NoOp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

-- VIEW

eventsBox : Model -> Html
eventsBox model =
  textarea [ ] [ ]

view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
    [ Location.Planet.view model.location,
      Character.Player.view model.player,
      eventsBox model ]

-- WIRE IT ALL TOGETHER


mainApp : StartApp.App Model Action
mainApp =
  { model = initialModel (Random.initialSeed Native.Now.loadTime),
    view = view,
    update = update
  }

main : Signal Html
main = StartApp.start (mainApp)

