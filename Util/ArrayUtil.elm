module Util.ArrayUtil where

import Array exposing (Array)
import Maybe
import Random

randomArrayElement : Random.Seed -> Array a -> a -> (a, Random.Seed)
randomArrayElement seed array default =
  let
    (randomIndex, seed') = Random.generate (Random.int 0 (Array.length array-1)) seed
    randomElement = Maybe.withDefault default (Array.get randomIndex array)
  in
    (randomElement, seed')

last : Array a -> a -> a
last array default =
  Maybe.withDefault default (Array.get (Array.length array - 1) array)