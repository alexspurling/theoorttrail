module Util.RandomUtil where

import Array exposing (Array)
import Random exposing (..)

randomInt seed maxInt =
  generate (int 0 maxInt) seed

seedArray : Int -> Seed -> Array Seed
seedArray length seed =
  let
    (seedValues, _) = generate (list length (int minInt maxInt)) seed
  in
    Array.fromList (List.map (\n -> initialSeed n) seedValues)
