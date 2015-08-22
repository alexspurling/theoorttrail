module Location.Galaxy where

import Array exposing (Array)
import Basics exposing (floor)
import Debug
import Random

import Util.ArrayUtil as ArrayUtil
import Location.Planet exposing (Planet, planetNames, getRandomPlanet)
import Util.RandomUtil as Rand
import Util.Game exposing (..)

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
    shuffledPlanetNames = Rand.shuffleList planetNames seed
    seedList = (Rand.seedList 100 seed)
    planetList = List.map2 getRandomPlanet shuffledPlanetNames seedList
    newPlanets = Array.fromList planetList
    newPlanetPositions = randomPlanetPositions seed newPlanets
    foo = Debug.log "positions" newPlanetPositions
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

getPlanet index planets =
  Maybe.withDefault dummyPlanet (Array.get index planets)

getPlanetPosition : Int -> Array Pos -> Pos
getPlanetPosition index planetPositions =
  Maybe.withDefault (0,0) (Array.get index planetPositions)

startingPlanet : Galaxy -> Planet
startingPlanet galaxy =
  let
    planet = getPlanet 0 galaxy.planets
    nearestPlanetDistances = nearestPlanets 0 galaxy.planetPositions
    nps = List.map
      (\(index, distance) ->
        let
          nearbyPlanet = getPlanet index galaxy.planets
        in
          (nearbyPlanet.name, distance))
      nearestPlanetDistances
  in
    {planet | nearestPlanets <- nps}

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

nearestPlanets : Int -> Array Pos -> List (Int, Float)
nearestPlanets currentPlanet planetPositions =
  let
    currentPos = getPlanetPosition currentPlanet planetPositions
    curX = Basics.toFloat (Basics.fst currentPos)
    curY = Basics.toFloat (Basics.snd currentPos)
    distances =
      Array.indexedMap
          (\index (x, y) ->
            let
              dx = (Basics.toFloat x - curX)
              dy = (Basics.toFloat y - curY)
            in
              (index, sqrt (dx ^ 2 + dy ^ 2)))
          planetPositions
    foo = Debug.log "distances" distances
  in
    distances
      |> Array.toList
      |> List.sortBy (\(index, distance) -> distance)
      |> List.take 4