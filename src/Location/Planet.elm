module Location.Planet where

import Html exposing (..)
import Html.Attributes exposing (..)

import Array exposing (Array)
import Basics exposing (cos, sin, pi)
import Debug
import Random

import Util.ArrayUtil as ArrayUtil
import Util.RandomUtil as Rand

planetNames : List String
planetNames = [
  "1249 Scuti III",
  "2713 Antliae VII",
  "2780 Pushya VII",
  "3876 Liu Xiu VII",
  "3887 Sagittae Prime",
  "4410 Scuti V",
  "6385 Lyncis VII",
  "8112 Gui Xiu VI",
  "8886 Kui Xiu Prime",
  "9100 Magha Prime",
  "Almaren",
  "Anu",
  "Asherah",
  "Balha II",
  "Cybele Prime",
  "D'Endan",
  "Dari II",
  "Di-Yu",
  "Dr'Mado",
  "Emhan Betu",
  "Enlil",
  "Ganiea",
  "Hura VII",
  "Iahamu III",
  "Keniea VI",
  "Lurma III",
  "Mara R'Vani",
  "Metra",
  "Minbe",
  "Natha",
  "New Britain",
  "New Gaia",
  "New Rhea",
  "New Terra",
  "New Thyoph",
  "New Titan",
  "New Triton",
  "New Xena",
  "Niano",
  "Shu VII",
  "Sietynas IV",
  "Skadi II",
  "Sycia II",
  "Tando",
  "Tane T'Agan",
  "Tholy Prime",
  "Tipa",
  "Vogi IV",
  "Zakar VII" ]

planetImages : Array String
planetImages = Array.fromList [
  "assets/planets/earth.png",
  "assets/planets/desert.png",
  "assets/planets/ice.png",
  "assets/planets/p1shaded.png",
  "assets/planets/p2shaded.png",
  "assets/planets/p3shaded.png",
  "assets/planets/p4shaded.png",
  "assets/planets/p5shaded.png",
  "assets/planets/p6shaded.png",
  "assets/planets/p7shaded.png",
  "assets/planets/p8shaded.png",
  "assets/planets/p9shaded.png",
  "assets/planets/p10shaded.png" ]

planetClasses : Array String
planetClasses = Array.fromList [
  "Rocky",
  "Icy",
  "Gas Giant" ]

type alias Planet =
  { name : String,
    image : String,
    population : Int,
    class : String,
    nearestPlanets : List (String, Float)
  }

getRandomPlanet : String -> Random.Seed -> Planet
getRandomPlanet planetName seed =
  let
    --get the planet index and base all random values on that
    (planetImage, seed1) = ArrayUtil.randomArrayElement seed planetImages "Earth"
    (planetPopulation, seed2) = (Rand.randomInt seed1 10000)
    (planetPopulationMultiplier, seed3) = (Rand.randomInt seed2 8)
    (planetClass, seed4) = ArrayUtil.randomArrayElement seed planetClasses "Rocky"
  in
    { name = planetName,
      image = planetImage,
      population = planetPopulation * (10 ^ planetPopulationMultiplier),
      class = planetClass,
      nearestPlanets = []
    }

--VIEW

planetName : String -> Html
planetName name =
  h2 [ ] [ text name ]

stats : Planet -> Html
stats planet =
  p [ ]
    [ text ("Population: " ++ (toString planet.population)), br [ ] [ ],
      text ("Class: " ++ planet.class), br [ ] [ ]
    ]

view : Planet -> Html
view planet =
  div [ ]
    [
      img [ src planet.image, class "avatar" ] [ ],
      planetName planet.name
    ]