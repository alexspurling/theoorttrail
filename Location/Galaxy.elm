module Location.Galaxy where

import Array exposing (Array)
import Random

import Util.ArrayUtil as ArrayUtil
import Location.Planet exposing (Planet, randomPlanet)
import Util.RandomUtil as Rand

type alias Galaxy =
  {
    planets : Array Planet
  }

newGalaxy : Random.Seed -> Galaxy
newGalaxy seed =
  {
    planets = Array.map randomPlanet (Rand.seedArray 10 seed)
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