module Util.Game where

import Time exposing (Time)

type alias Pos = (Int, Int)

type GameAction
  = NoOp
  | Tick Time
  | StartNews
  | StartExplore
  | StartTrade
  | ShowNearby
  | StartTravel Int