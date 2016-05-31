{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

{-
    Run this example by doing

    $ stack runghc -- -ilib:examples examples/MuppetShow/Episode.hs

    or similar.
-}

module MuppetShow.Episode where

import Data.List (intercalate)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T

import Rosterium.Allocatus
import MuppetShow.Cast

main :: IO ()
main = do
    available <- load' performers 3141592
    roster <- allocate 13 available

    putStrLn $ intercalate "\n" $ fmap show . rosterPeople $ roster

