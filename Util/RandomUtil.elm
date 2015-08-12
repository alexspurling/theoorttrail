module Util.RandomUtil where

import Array exposing (Array)
import Random exposing (..)

randomInt seed maxInt =
  generate (int 0 maxInt) seed

seedArray : Int -> Seed -> Array Seed
seedArray length seed =
  Array.fromList (seedList length seed)

seedList : Int -> Seed -> List Seed
seedList length seed =
  let
    (seedValues, _) = generate (list length (int minInt maxInt)) seed
  in
    List.map (\n -> initialSeed n) seedValues

zip = List.map2 (,)

shuffleList : List a -> Seed -> List a
shuffleList listToShuffle seed =
  let
    (randomInts, _) = generate (list (List.length listToShuffle) (int minInt maxInt)) seed
    zippedLists = zip listToShuffle randomInts
    shuffledList = List.sortBy snd zippedLists
  in
    List.map fst shuffledList

