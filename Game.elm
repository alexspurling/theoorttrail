module Game where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp
import Signal exposing (Address)

import Character.Player exposing (Player)

-- MODEL

type alias Model =
  { player : Player
  }

initialModel : Model
initialModel =
  { player = Character.Player.daveHardbrain
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

listElement theText =
  p [ ]
    [ text theText ]

playerName name =
  h2 [ ] [ text name ]

stats s =
  p [ ]
    [ text ("Atk: " ++ (toString s.attack)), br [ ] [ ],
      text ("Int: " ++ (toString s.intelligence)), br [ ] [ ],
      text ("Def: " ++ (toString s.defence)), br [ ] [ ]
    ]

health h =
  p [ ]
    [ text ("Health: " ++ (toString h)) ]

player : Model -> Html
player model =
  div [ class "panel" ]
    [
      img [ src "assets/hardbrain.png", class "avatar" ] [ ],
      playerName model.player.name,
      stats model.player.stats,
      health model.player.health
    ]

eventsBox : Model -> Html
eventsBox model =
  textarea [ ] [ ]

view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
    [ player model,
      eventsBox model ]

-- WIRE IT ALL TOGETHER

main : Signal Html
main =
  StartApp.start
  { model = initialModel,
    view = view,
    update = update
  }
