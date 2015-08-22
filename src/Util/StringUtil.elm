module Util.StringUtil where

import String
import Char
import Bitwise

{-| Return the hashcode for the given string.

Implements the same algorithm as Java's String.hashCode() method
-}
hashCode : String -> Int
hashCode s =
  String.foldl partialHash 0 s

{-- This is needed because we need to restrict the hash value to 32 bits. We
do this by ANDing the hash with itself --}
partialHash : Char -> Int -> Int
partialHash char hash =
  let
    newHash = (Char.toCode char) + ((Bitwise.shiftLeft hash 5) - hash)
  in
    Bitwise.and newHash newHash