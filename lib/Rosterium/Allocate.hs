module Rosterium.Allocate where

import System.Random (StdGen, split)
import System.Random.Shuffle (shuffle')

import Rosterium.Types

--
-- | Draw count randomly from the bench of people available. Will chose each
-- person once until the bench is exhausted, then will reshuffle the deck and
-- resume drawing.
--
allocate :: Int -> Bench a -> Roster a
allocate count (Bench avail gen) = Roster $ take count $ generate gen avail

-- infinite
generate :: StdGen -> [a] -> [a]
generate gen bench =
  let
    width = length bench
    (gen1,gen2) = split gen
    next = shuffle' bench width gen1
  in
    next ++ generate gen2 bench

