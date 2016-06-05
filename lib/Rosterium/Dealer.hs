{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Dealer where

import Control.Monad.State
import qualified Data.Map.Strict as Map
import Data.Vector (Vector)
import qualified Data.Vector as V
import Data.Word
import System.Random.MWC

import Rosterium.Types

allocateN :: Int -> [p] -> GenIO -> IO [p]
allocateN count avail gen = do
    let width = length avail 
    list <- shuffle gen avail
    if count < width
        then do
            return (take count list)
        else do
            list' <- allocateN (count - width) avail gen
            return (list ++ list')

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
    


