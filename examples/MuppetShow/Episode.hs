{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

{-
    Run this example by doing:

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

singers :: Muppet -> Bool
singers (Muppet _ _ _ talents) = Sings `elem` talents

main :: IO ()
main = do
    roster $ do
        label "Random singers"
        load performers
        restrict singers
        allocate 2

    roster' 3141592 $ do
        label "Baker's dozen"
        load performers 
        allocate 13

    return ()
