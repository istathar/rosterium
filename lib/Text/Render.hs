{-# LANGUAGE OverloadedStrings #-}

module Text.Render (
    module Export,
    Render(..),
    indefinite
) where

import Data.Text (Text)
import qualified Data.Text as Export (Text)
import qualified Data.Text as T

class Render a where
    render :: a -> Text

--
-- | Render "a" or "an" in front of a word depending on English's idea of
-- whether it's a vowel or not.
--
indefinite :: Text -> Text
indefinite text =
  let
    article = if T.head text `elem` ['A','E','I','O','U','a','e','i','o','u']
        then "an "
        else "a "
  in
    if T.null text
        then T.empty
        else T.append article text

