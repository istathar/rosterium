{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Dealer where

import qualified Data.Map.Strict as Map
import Data.Vector (Vector)
import qualified Data.Vector as V
import Data.Word
import System.Random.MWC

allocateN :: Int -> [p] -> [p] -> GenIO -> IO ([p],[p])
allocateN count leftover avail gen = do
    let width = length leftover + length avail
    list <- shuffle gen avail
    if count < width
        then do
            return (splitAt count (leftover ++ list))
        else do
            (list',remains) <- allocateN (count - width) [] avail gen
            return (leftover ++ list ++ list', remains)

--
-- Generate a random array, use those values as keys to insert list elements
-- into a Map, then read the map out in key order to result in a shuffled list.
--
shuffle :: GenIO -> [p] -> IO [p]
shuffle gen values =
  let
    width = length values
  in do
    variates <- uniformVector gen width :: IO (Vector Word64)
    let numbers = V.toList variates
    let pairs = zip numbers values
    return $ Map.elems . Map.fromList $ pairs
    
