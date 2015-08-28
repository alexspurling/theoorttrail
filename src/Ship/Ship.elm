module Ship.Ship where

import Html exposing (..)
import Html.Attributes exposing (..)
import Util.Game exposing (..)

type alias Ship =
  { name : String,
    position : Pos,
    health : Int,
    shields : Int,
    status : String
    {--
    components : ShipComponent (could be an engine, a weapon, a docking port, a cargo bay etc)
    --}
  }

startingShip : Ship
startingShip =
  { name = "USS SS Susceptiple",
    position = (0,0),
    health = 100,
    shields = 100,
    status = "Orbiting"
  }


-- VIEW

shipName name =
  h2 [ ] [ text name ]

stats s =
  p [ ]
    [ text ("Health: " ++ (toString s.health)), br [ ] [ ],
      text ("Shields: " ++ (toString s.shields) ++ "%"), br [ ] [ ]
    ]

status s =
  p [ ]
    [ text ("Status: " ++ s.status) ]

view : Ship -> Html
view ship =
  div [ class "panel" ]
    [
      img [ src "assets/hardbrain.png", class "avatar" ] [ ],
      shipName ship.name,
      stats ship,
      status ship
    ]
