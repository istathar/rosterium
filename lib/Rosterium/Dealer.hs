{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Dealer where

import qualified Data.Map.Strict as Map
import Data.Vector (Vector)
import qualified Data.Vector as V
import Data.Word
import System.Random.MWC

import Rosterium.Types

--
-- | Draw count randomly from the bench of people available. Will chose each
-- person once until the bench is exhausted, then will reshuffle the deck and
-- resume drawing.
--
allocate :: Int -> Bench a -> IO (Roster a)
allocate count bench = do
    result <- allocate' count bench
    return (Roster result)

allocate' :: Int -> Bench a -> IO [a]
allocate' count bench@(Bench avail gen) = do
    let width = length avail 
    list <- shuffle gen avail
    if count < width
        then do
            return (take count list)
        else do
            list' <- allocate' (count - width) bench
            return (list ++ list')

--
-- Generate a random array, use those values as keys to insert list elements
-- into a Map, then read the map out in key order to result in a shuffled list.
--
shuffle :: GenIO -> [a] -> IO [a]
shuffle gen values =
  let
    width = length values
  in do
    variates <- uniformVector gen width :: IO (Vector Word64)
    let numbers = V.toList variates
    let pairs = zip numbers values
    return $ Map.elems . Map.fromList $ pairs
    


