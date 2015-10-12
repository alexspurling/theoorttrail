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
    clockTime : Time,
    fps : Float
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
    clockTime = 0.0,
    fps = 0.0
  }

-- UPDATE

update : GameAction -> Model -> (Model, Effects GameAction)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)
    ShowNearby ->
      ({ model | location <- Location.Planet.showNearbyPlanets model.location },
      Effects.none)
    StartTravel newLocation ->
      ({ model | location <- Location.Planet.startTravel model.location newLocation },
      Effects.tick Tick)
    Tick clockTime ->
      updateTick clockTime model

updateTick : Time -> Model -> (Model, Effects GameAction)
updateTick clockTime model =
  let
    curFrameSpeed = 1000 * Time.millisecond / (clockTime - model.clockTime)
    fps = (model.fps * 0.99) + (curFrameSpeed * 0.01)
  in
    ({ model |
         clockTime <- clockTime,
         fps <- fps
     }, Effects.tick Tick)

{--
updateFps : Time -> Model
updateFps clockTime model =
  let
    timeSinceLastUpdate = clockTime - model.clockTime
    elapsed = model.elapsed + timeSinceLastUpdate
    updatePeriod = (1000 * Time.millisecond)
    newElapsed = if elapsed < updatePeriod then elapsed else elapsed - updatePeriod
  in
--}

-- VIEW

eventsBox : Model -> Html
eventsBox model =
  h2 [ ] [ text (toString model.fps) ]

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