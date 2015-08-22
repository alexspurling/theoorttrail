module Character.Player where

import Html exposing (..)
import Html.Attributes exposing (..)
import Random exposing (..)

import Array

import Util.ArrayUtil

maleFirstNames = Array.fromList [
  "Aaron",
  "Aden",
  "Arnold",
  "Benedict",
  "Brandon",
  "Chad",
  "Dave",
  "Ethan",
  "Felix",
  "Howard",
  "Jim",
  "Luke",
  "Mike",
  "Roger",
  "Tim",
  "Tyrell",
  "Waldo" ]

lastNames = Array.fromList [
  "Ableton",
  "Adamsen",
  "Bauer",
  "Christianson",
  "Dragen",
  "Forsley",
  "Hagebak",
  "Hordor",
  "Hoyer",
  "Kessler",
  "Land",
  "Llewellyn",
  "McCoughphlem",
  "Snow",
  "Stöhr",
  "Sterling",
  "Tornquist",
  "Winter" ]


type alias Player =
  { name : String,
    stats : PlayerStats,
    health : Int
  }

type alias PlayerStats =
  { attack : Int,
    intelligence : Int,
    defence : Int,
    level: Int,
    exp: Int
  }

daveHardbrainStats : PlayerStats
daveHardbrainStats =
  { attack = 15,
    intelligence = 5,
    defence = 6,
    level = 1,
    exp = 0
  }

daveHardbrain : Player
daveHardbrain =
  { name = "Dave Hardbrain",
    stats = daveHardbrainStats,
    health = 150
  }


randomPlayer : Seed -> Player
randomPlayer seed =
  let
    (firstName, seed') = Util.ArrayUtil.randomArrayElement seed maleFirstNames "Emily"
    (lastName, seed'') = Util.ArrayUtil.randomArrayElement seed' lastNames "Surname"
  in
    { name = firstName ++ " " ++ lastName,
      stats = daveHardbrainStats,
      health = 150
    }



--VIEW

playerName name =
  h2 [ ] [ text name ]

stats s =
  p [ ]
    [ text ("Atk: " ++ (toString s.attack)), br [ ] [ ],
      text ("Int: " ++ (toString s.intelligence)), br [ ] [ ],
      text ("Def: " ++ (toString s.defence)), br [ ] [ ],
      text ("Lvl: " ++ (toString s.level)), br [ ] [ ],
      text ("Exp: " ++ (toString s.exp)), br [ ] [ ]
    ]

health h =
  p [ ]
    [ text ("Health: " ++ (toString h)) ]

view : Player -> Html
view player =
  div [ class "panel" ]
    [
      img [ src "assets/hardbrain.png", class "avatar" ] [ ],
      playerName player.name,
      stats player.stats,
      health player.health
    ]
