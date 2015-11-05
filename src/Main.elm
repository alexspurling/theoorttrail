module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import StartApp
import Effects exposing (Effects, Never)
import Signal exposing (Address, (<~))
import Random
import Task
import Time exposing (Time)

import Debug

import Character.Player exposing (Player)
import Location.Planet exposing (Planet)
import Location.Galaxy exposing (Galaxy)
import Ship.Ship exposing (Ship)

import Native.Now

-- MODEL

type GameAction
  = NoOp
  | StartNews
  | StartExplore
  | StartTrade
  | StartTravel String
  | ShowNearby
  | Tick Time

type ViewState
  = Default
  | Nearby

type alias Model =
  { player : Player,
    galaxy : Galaxy,
    visiting : Planet,
    ship : Ship,
    state: ViewState,
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
    visiting = startingPlanet,
    ship = newShip,
    state = Default,
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
      ({ model | state <- Nearby }, Effects.none)
    StartTravel planetName ->
      let
        foo = Debug.log "Selected planet" planetName
      in
        (model, Effects.none)

{--
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

planetActions : Address GameAction -> Html
planetActions address =
  div [ class "actionpanel" ]
    [
      button [ class "actionbutton", onClick address StartNews ] [ text "News" ],
      button [ class "actionbutton", onClick address StartExplore ] [ text "Explore" ],
      button [ class "actionbutton", onClick address StartTrade ] [ text "Trade" ],
      button [ class "actionbutton", onClick address ShowNearby ] [ text "Travel" ]
    ]

displayDistance : Float -> String
displayDistance distance =
  if distance == 0 then
    " (Visiting)"
  else
    " (" ++ (roundDistance distance) ++ " ly)"

roundDistance : Float -> String
roundDistance distance =
  if distance < 10 then
    --Round to a single decimal place
    toString ((toFloat (floor (distance * 10))) / 10)
  else
    --Otherwise we just show the integer value
    toString <| toFloat <| floor distance

nearestPlanetsView : Address GameAction -> Planet -> Html
nearestPlanetsView address planet =
  div [ ]
    [ text ("Travel to:"), br [ ] [ ],
      ul [ ]
        (List.map (\(planetName, distance) ->
          li [ onClick address (StartTravel planetName) ] [ text (planetName ++ displayDistance distance) ])
        planet.nearestPlanets)
    ]

view : Address GameAction -> Model -> Html
view address model =
  let
    componentHtml =
      case model.state of
        Default ->
          Location.Planet.stats model.visiting
        Nearby ->
          nearestPlanetsView address model.visiting
  in
    div [ class "game" ]
      [ div [ class "gamepanel" ]
        [ Ship.Ship.view model.ship,
          div [ class "panel" ]
            [
              Location.Planet.view model.visiting,
              componentHtml,
              planetActions address
            ]
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

app : StartApp.App Model
app =
  StartApp.start
    { init = (initialModel (Random.initialSeed Native.Now.loadTime), Effects.none)
    , update = update
    , view = view
    , inputs = []
    }

main : Signal Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks