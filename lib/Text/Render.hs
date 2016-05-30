module Text.Render (
    module Export,
    Render(..)
) where

import Data.Text (Text)
import qualified Data.Text as Export (Text)

class Render a where
    render :: a -> Text


