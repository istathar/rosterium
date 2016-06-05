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
    restrict,
    allocate
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
newtype RosterBuilder p a = Construct (StateT (Roster p) IO a)
  deriving (Functor, Applicative, Monad, MonadState (Roster p), MonadIO)

roster :: Person p => RosterBuilder p a -> IO (Roster p)
roster (Construct monad) = do
    gen <- createSystemRandom
    execBuilder gen monad



--
-- | Return a Bench whose internal random number generator state is seeded by
-- the supplied number.
--
roster' :: Person p => Int -> RosterBuilder p a -> IO (Roster p)
roster' number (Construct monad) =
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
load :: Person p => [p] -> RosterBuilder p ()
load persons = do
    current <- get
    let update = current {
        rosterBench = persons
    }
    put update



--
-- This is just 'filter' obviously
--
restrict :: Person p => (p -> Bool) -> RosterBuilder p ()
restrict predicate = do
    current <- get
    let selected = rosterSelected current
    let selected' = filter predicate selected
    let update = current {
        rosterSelected = selected'
    }
    put update

--
-- | Draw count randomly from the bench of people available. Will chose each
-- person once until the bench is exhausted, then will reshuffle the deck and
-- resume drawing.
--
allocate :: Person p => Int -> RosterBuilder p [p]
allocate count = do
    current <- get
    let bench = rosterSelected current
    let gen = rosterRandom current
    result <- liftIO $ allocateN count bench gen
    return result

