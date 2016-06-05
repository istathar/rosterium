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
    allocate,
    label
) where

import Control.Monad.State
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Data.Vector as V
import System.Random.MWC (GenIO, createSystemRandom, initialize)

import Rosterium.Types (Person)
import Rosterium.Dealer (allocateN)
import Text.Render

--
-- Roster is now a state object used when building.
--
data Roster p = Roster {
    rosterRandomGen :: GenIO,
    rosterBenchList :: Person p => [p]
}


--
-- | The RosterBuilder monad allows you to abuse do-notation to
-- setup a 'Roster' object.
--
newtype RosterBuilder p a = Construct (StateT (Roster p) IO a)
  deriving (Functor, Applicative, Monad, MonadState (Roster p), MonadIO)

--
-- | Carry out a roster allocation.
--
{-
    In both cases, we throw away the result of running the state monad; in the
    current version we assume the allocate action emits something to stdout.
    I'd prefer something a bit more pure but at present this makes for a
    useable enough DSL.
-}
roster :: Person p => RosterBuilder p a -> IO ()
roster (Construct monad) = do
    gen <- createSystemRandom
    _   <- execBuilder gen monad
    return ()

--
-- | Carry out a roster allocation where the internal random number generator
-- state is seeded by the supplied number.
--
roster' :: Person p => Int -> RosterBuilder p a -> IO ()
roster' number (Construct monad) =
  let
    vector = V.singleton (fromIntegral number)
  in do
    gen <- initialize vector
    _   <- execBuilder gen monad
    return ()

execBuilder :: Person p => GenIO -> StateT (Roster p) IO a -> IO (Roster p)
execBuilder gen monad = do
    let initial = Roster {
        rosterRandomGen = gen,
        rosterBenchList = []
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
        rosterBenchList = persons
    }
    put update

--
-- This is just 'filter' obviously
--
restrict :: Person p => (p -> Bool) -> RosterBuilder p ()
restrict predicate = do
    current <- get
    let selected = rosterBenchList current
    let selected' = filter predicate selected
    let update = current {
        rosterBenchList = selected'
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
    let bench = rosterBenchList current
    let gen = rosterRandomGen current
    liftIO $ do
        result <- allocateN count bench gen
        mapM_ (T.putStrLn . render) result
        putStrLn ""
        return result

--
-- | Output a heading and underline it.
--
label :: MonadIO m => String -> m ()
label text =
  let
    width = length text
  in liftIO $ do
    putStrLn text
    putStrLn $ replicate width '-'
    putStrLn ""
