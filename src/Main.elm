module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Array exposing (Array)
import StartApp
import Effects exposing (Effects, Never)
import Signal exposing (Address, (<~))
import Random
import Time exposing (Time, second)
import Task

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
    ship : Ship,
    currentTime : Time
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
    ship = newShip,
    currentTime = 0.1
  }

-- UPDATE

update : GameAction -> Model -> (Model, Effects GameAction)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)
    StartTravel ->
      ({ model | location <- Location.Planet.showNearbyPlanets model.location },
      Effects.tick Tick)
    Tick clockTime ->
      ({ model | currentTime <- clockTime }, Effects.tick Tick)

-- VIEW

eventsBox : Model -> Html
eventsBox model =
  h2 [ ] [ text (toString model.currentTime) ]

view : Address GameAction -> Model -> Html
view address model =
  div [ class "game" ]
    [ div [ class "gamepanel" ]
      [ Ship.Ship.view model.ship,
        Location.Planet.view address model.location
      ],
      eventsBox model ]

-- WIRE IT ALL TOGETHER

{--
mainApp : StartApp.App Model
mainApp =
  { model = initialModel (Random.initialSeed Native.Now.loadTime),
    view = view,
    update = update
  }
--}

app =
  StartApp.start
    { init = (initialModel (Random.initialSeed Native.Now.loadTime), Effects.none)
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks