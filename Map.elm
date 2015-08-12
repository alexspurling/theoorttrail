import Array exposing (Array)
import Basics exposing (toFloat)
import Color exposing (..)
import Debug
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Random

import Location.Planet

main : Element
main =
  Graphics.Collage.collage 700 420
    [ blueSquare, redSquare
    ]

linestyle : LineStyle
linestyle = { color = blue, width = 1, cap = Flat, join = Smooth, dashing = [], dashOffset = 0 }

blueSquare : Form
blueSquare =
  traced linestyle square

redSquare : Form
redSquare =
  traced (solid red) (Graphics.Collage.path [(0,0), (10, 10)])

type alias Pos = (Int, Int)

distanceBetweenPoints : Array Pos -> Array Float
distanceBetweenPoints array =
  Array.indexedMap
    (\pos (x, y) ->
      let
        (prevX, prevY) = Maybe.withDefault (0,0) (Array.get (pos-1) array)
        dx = (x - prevX)
        dy = (y - prevY)
      in
        sqrt (dx ^ 2 + dy ^ 2))
    array


square : Path
square =
  let
    positionArray = Location.Planet.randomPlanetPositions (Random.initialSeed 12) Location.Planet.planetNames
    a = Debug.log "pos" positionArray
    distanceArray = distanceBetweenPoints positionArray
    b = Debug.log "distance" distanceArray
  in
    Graphics.Collage.path (List.map (\(f1, f2) -> (toFloat f1 * 0.5, toFloat f2 * 0.5)) (Array.toList positionArray))
