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

import Native.Now

-- MODEL

type alias Model =
  { player : Player,
    galaxy : Array.Array Location.Planet.Planet,
    location : Planet
  }

initialModel : Random.Seed -> Model
initialModel initialSeed =
  let
    randomGalaxy = Location.Planet.galaxy initialSeed
    startingPlanet = Location.Planet.startingPlanet randomGalaxy
  in
  { player = Character.Player.randomPlayer initialSeed,
    galaxy = randomGalaxy,
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

