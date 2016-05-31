{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Setup where

import qualified Data.Vector as V
import System.Random.MWC

import Rosterium.Types

--
-- | Holds the random number generator state so that we can continue to draw from
-- the same sequence as we continue populating rosters.
--
load :: Person a => [a] -> IO (Bench a)
load persons = do
    gen <- createSystemRandom
    return (Bench persons gen)

--
-- | Return a Bench whose internal random number generator state is seeded by
-- the supplied number.
--
load' :: Person a => [a] -> Int -> IO (Bench a)
load' persons number =
  let
    vector = V.singleton (fromIntegral number)
  in do
    gen <- initialize vector
    return (Bench persons gen)
