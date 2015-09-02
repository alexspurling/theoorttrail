module Util.Game where

type alias Pos = (Int, Int)

type GameAction
  = NoOp
  | StartNews
  | StartExplore
  | StartTrade
  | StartTravel