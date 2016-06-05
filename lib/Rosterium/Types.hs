{-# OPTIONS_HADDOCK hide, not-home #-}

module Rosterium.Types where

import Data.Text (Text)
import Text.Render (Render)

class Render a => Person a where
    name :: a -> Text
    handle :: a -> Text -- that we will restrict at load time


class Ord a => Grade a where
    --
    -- | Return the prefix text that describes this person's level
    --
    grade :: a -> Text


class Skill a where
    skill :: a -> Text

