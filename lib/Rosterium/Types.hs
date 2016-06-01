{-# OPTIONS_HADDOCK hide, not-home #-}

module Rosterium.Types where

import Data.Text (Text)
import System.Random.MWC (GenIO)

class Person a where
    name :: a -> Text
    handle :: a -> Text -- that we will restrict at load time


class Ord a => Grade a where
    --
    -- | Return the prefix text that describes this person's level
    --
    grade :: a -> Text


class Skill a where
    skill :: a -> Text

--
-- | The list of people eligible to be selected.  Current implementation is a
-- basic Data.List; this wrapper gives us the flexibility to switch to
-- something more advanced if needs be. That said, a lazy infinite list is an
-- ideal model for drawing Rosters from.
--
data Bench a = Bench {
    benchPeople :: [a],
    benchRandom :: GenIO
}

--
-- | The list of people who have been rostered on. The index is the position in
-- the list of people where we next resume populating the roster
--
