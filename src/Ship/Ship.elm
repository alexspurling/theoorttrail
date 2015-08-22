module Ship.Ship where

import Util.Game exposing (..)

type alias Ship =
  { name : String,
    position : Pos,
    health : Int
    {--
    components : ShipComponent (could be an engine, a weapon, a docking port, a cargo bay etc)
    --}
  }

startingShip : Ship
startingShip =
  { name = "USS SS Susceptiple",
    position = (0,0),
    health = 100
  }