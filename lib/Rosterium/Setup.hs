{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Setup where

import System.Random.MWC

import Rosterium.Types

--
-- | The index into the list of people where we next resume populating the roster
--
load :: Person a => [a] -> GenIO -> IO (Bench a)
load persons gen = return (Bench persons gen)
