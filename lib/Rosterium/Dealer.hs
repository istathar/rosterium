{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Dealer where

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
allocate count bench@(Bench avail gen) =
  let
    width = length avail 
  in do
    list <- shuffle gen avail
    if count < width
        then return (Roster (take count list))
        else do
            list' <- allocate (count - width) bench
            return undefined

-- HERE change this to something that shuffles using random sequence into a pqueue
shuffle :: GenIO -> [a] -> IO [a]
shuffle gen bench =
  let
    width = length bench
  in do
    vs <- uniformVector gen width :: IO (Vector Word32)
    return undefined
    


