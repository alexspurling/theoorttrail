module Location.Galaxy where

import Array exposing (Array)
import Random

import Util.ArrayUtil as ArrayUtil
import Location.Planet exposing (Planet, randomPlanet)
import Util.RandomUtil as Rand

type alias Galaxy =
  {
    planets : Array Planet,
    planetPositions : Array Pos
  }

newGalaxy : Random.Seed -> Galaxy
newGalaxy seed =
  let
    --Get a new galaxy of planets by generating an array of seeds
    --and mapping that array to the randomPlanet function
    newPlanets = Array.map randomPlanet (Rand.seedArray 10 seed)
    newPlanetPositions = randomPlanetPositions seed newPlanets
  in
  {
    planets = newPlanets,
    planetPositions = newPlanetPositions
  }

--If we ever land on this planet, something has gone wrong
dummyPlanet =
  { name = "Fail",
    image = "Fail",
    population = 0,
    nearestPlanets = []
  }

startingPlanet : Galaxy -> Planet
startingPlanet galaxy =
  ArrayUtil.first galaxy.planets dummyPlanet


type alias Pos = (Int, Int)

{-- Generates an array of random positions no more than a certain distance
from the last position. It does this by folding over the input array, taking
the seed and position from the previous element of the array built up so far.
This is effectively the same as mapping over a memoized recursive function.
--}
randomPlanetPositions : Random.Seed -> Array Planet -> Array Pos
randomPlanetPositions initialSeed planets =
  Array.map (\(pos, seed) -> pos)
    (Array.foldl
      (\planet planetPositions ->
        let
          --Base the new position on the value of the last position
          --If the current planetPositions array is empty, the default position and seed are returned
          (previousPos, seed) = ArrayUtil.last planetPositions ((0,0), initialSeed)
          tau = pi * 2
          (newAngle, seed') = Random.generate (Random.float 0 tau) seed
          (newDistance, seed'') = Random.generate (Random.float 1 100) seed'
          newX = floor ((cos newAngle) * newDistance) + (fst previousPos)
          newY = floor ((sin newAngle) * newDistance) + (snd previousPos)
          newPos = (newX, newY)
        in
          Array.push (newPos, seed'') planetPositions)
      Array.empty
      planets)

nearestPlanets : Pos -> Array Pos -> List Float
nearestPlanets (planetX, planetY) planetPositions =
  let
    distances =
      Array.map
          (\(x, y) ->
            let
              dx = (x - 0)
              dy = (y - 0)
            in
              sqrt (dx ^ 2 + dy ^ 2))
          planetPositions
  in
    distances
      |> Array.toList
      |> List.sort
      |> List.take 3