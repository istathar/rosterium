{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Setup where

import System.Random

import Rosterium.Types

type Seed = Int

--
-- | The index into the list of people where we next resume populating the roster
--
load :: Person a => [a] -> Seed -> Bench a
load persons seed =
  let
    gen = mkStdGen seed
  in
    Bench persons gen
