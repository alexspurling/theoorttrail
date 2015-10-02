module Main where

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
import Ship.Ship exposing (Ship)
import Util.Game exposing (GameAction(..))

import Native.Now

-- MODEL

type alias Model =
  { player : Player,
    galaxy : Galaxy,
    location : Planet,
    ship : Ship
  }

initialModel : Random.Seed -> Model
initialModel initialSeed =
  let
    newGalaxy = Location.Galaxy.newGalaxy initialSeed
    startingPlanet = Location.Galaxy.startingPlanet newGalaxy
    newShip = Ship.Ship.startingShip
  in
  { player = Character.Player.randomPlayer initialSeed,
    galaxy = newGalaxy,
    location = startingPlanet,
    ship = newShip
  }

-- UPDATE

update : GameAction -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    StartTravel ->
      { model | location <- Location.Planet.showNearbyPlanets model.location }

-- VIEW

eventsBox : Model -> Html
eventsBox model =
  textarea [ ] [ ]

view : Address GameAction -> Model -> Html
view address model =
  div [ class "game" ]
    [ div [ class "gamepanel" ]
      [ Ship.Ship.view model.ship,
        Location.Planet.view address model.location
      ],
      eventsBox model ]

-- WIRE IT ALL TOGETHER


mainApp : StartApp.App Model GameAction
mainApp =
  { model = initialModel (Random.initialSeed Native.Now.loadTime),
    view = view,
    update = update
  }

main : Signal Html
main = StartApp.start (mainApp)

