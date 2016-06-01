{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_HADDOCK hide #-}

module Rosterium.Setup (
    RosterBuilder,
    Roster(..),
    roster,
    roster',
    load,
    restrict
) where

import Control.Monad.State
import qualified Data.Vector as V
import System.Random.MWC

import Rosterium.Types

--
-- Roster is now a state object used when building.
--
data Roster p = Roster {
    rosterRandom   :: GenIO,
    rosterBench    :: Person p => [p],
    rosterSelected :: Person p => [p]
}


--
-- | The RosterBuilder monad allows you to abuse do-notation to
-- setup a 'Roster' object.
--
newtype RosterBuilder p a = RosterBuilder (StateT (Roster p) IO a)
  deriving (Functor, Applicative, Monad, MonadState (Roster p), MonadIO)

roster :: Person p => StateT (Roster p) IO a -> IO (Roster p)
roster monad = do
    gen <- createSystemRandom
    execBuilder gen monad



--
-- | Return a Bench whose internal random number generator state is seeded by
-- the supplied number.
--
roster' :: Person p => Int -> StateT (Roster p) IO a -> IO (Roster p)
roster' number monad =
  let
    vector = V.singleton (fromIntegral number)
  in do
    gen <- initialize vector
    execBuilder gen monad

execBuilder :: GenIO -> StateT (Roster p) IO a -> IO (Roster p)
execBuilder gen monad = do
    let initial = Roster {
        rosterRandom = gen,
        rosterBench = [],
        rosterSelected = []
    }
    execStateT monad initial

--
-- | Holds the random number generator state so that we can continue to draw from
-- the same sequence as we continue populating rosters.
--
load :: Person p => [p] -> StateT (Roster p) IO ()
load persons = do
    current <- get
    let update = current {
        rosterBench = persons
    }
    put update



--
-- This is just 'filter' obviously
--
restrict :: Person p => (p -> Bool) -> StateT (Roster p) IO ()
restrict predicate = do
    current <- get
    let selected = rosterSelected current
    let selected' = filter predicate selected
    let update = current {
        rosterSelected = selected'
    }
    put update
