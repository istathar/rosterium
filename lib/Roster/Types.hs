module Roster.Types where

import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as S
import Data.Text (Text)

data Person = Person {
    name :: Text,
    handle :: ByteString
}

class Ord a => Grade a where
    --
    -- | Return the prefix text that describes this person's level
    --
    grade :: a -> Text


class Skill a where
    skill :: a -> Text

