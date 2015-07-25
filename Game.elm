module Game where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp
import Signal exposing (Address)
import BingoUtils as Utils
-- MODEL

type alias Model =
  { person : Person
  }

type alias Person =
  { name : String,
    stats : Stats,
    health : Int
  }

type alias Stats =
  { attack : Int,
    intelligence : Int,
    defence : Int
  }

initialStats : Stats
initialStats =
  { attack = 10,
    intelligence = 5,
    defence = 6
  }

initialPerson : Person
initialPerson =
  { name = "Bob Monkfish",
    stats = initialStats,
    health = 100
  }

initialModel : Model
initialModel =
  { person = initialPerson
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

personName name =
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

person : Model -> Html
person model =
  div [ class "panel" ]
    [
      img [ src "assets/hardbrain.png", class "avatar" ] [ ],
      personName model.person.name,
      stats model.person.stats,
      health model.person.health
    ]

eventsBox : Model -> Html
eventsBox model =
  textarea [ ] [ ]

view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
    [ person model,
      eventsBox model ]

-- WIRE IT ALL TOGETHER

main : Signal Html
main =
  StartApp.start
  { model = initialModel,
    view = view,
    update = update
  }
