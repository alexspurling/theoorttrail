module Location.Planet where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Array
import Random

import Util.ArrayUtil

planetNames = Array.fromList [
  "Di-Yu",
  "New Titan",
  "Balha II",
  "Lurma III",
  "New Triton",
  "Mara R'Vani",
  "Hura VII",
  "New Rhea",
  "9100 Magha Prime",
  "Sycia II",
  "Minbe",
  "Tane T'Agan",
  "New Gaia",
  "Cybele Prime",
  "2713 Antliae VII",
  "Shu VII",
  "Emhan Betu",
  "Dr'Mado",
  "2780 Pushya VII",
  "Tando",
  "4410 Scuti V",
  "Keniea VI",
  "8112 Gui Xiu VI",
  "3887 Sagittae Prime",
  "New Rhea",
  "1249 Scuti III",
  "8886 Kui Xiu Prime",
  "Sietynas IV",
  "Zakar VII",
  "Metra",
  "Dari II",
  "Tipa",
  "Skadi II",
  "Vogi IV",
  "New Britain",
  "New Thyoph",
  "Anu",
  "D'Endan",
  "Enlil",
  "New Terra",
  "6385 Lyncis VII",
  "Tholy Prime",
  "Asherah",
  "3876 Liu Xiu VII",
  "Ganiea",
  "Niano",
  "New Xena",
  "Iahamu III",
  "Almaren",
  "Natha" ]


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


type alias Planet =
  { name : String,
    image : String,
    population : Int
  }

randomInt seed maxInt =
  Random.generate (Random.int 0 maxInt) seed

randomPlanet : Random.Seed -> Planet
randomPlanet seed =
  let
    --get the planet index and base all random values on that
    (planetIndex, _) = randomInt seed (Array.length planetNames-1)
    planetSeed = Random.initialSeed planetIndex
    (planetName, seed') = Util.ArrayUtil.randomArrayElement planetSeed planetNames "Earth"
    (planetImage, seed'') = Util.ArrayUtil.randomArrayElement seed' planetImages "Earth"
    (planetPopulation, seed''') = (randomInt seed'' 10000)
    (planetPopulationMultiplier, seed'''') = (randomInt seed''' 8)
  in
    { name = planetName,
      image = planetImage,
      population = planetPopulation * (10 ^ planetPopulationMultiplier)
    }

--VIEW

planetName name =
  h2 [ ] [ text name ]

stats : Planet -> Html
stats planet =
  p [ ]
    [ text ("Population: " ++ (toString planet.population)), br [ ] [ ]
    ]

view : Planet -> Html
view planet =
  div [ class "panel" ]
    [
      img [ src planet.image, class "avatar" ] [ ],
      planetName planet.name,
      stats planet
    ]