module Roster.Types where

import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as S
import Data.Text (Text)


class Person a where
    name :: a -> Text
    handle :: a -> ByteString


class Ord a => Grade a where
    --
    -- | Return the prefix text that describes this person's level
    --
    grade :: a -> Text


class Skill a where
    skill :: a -> Text

