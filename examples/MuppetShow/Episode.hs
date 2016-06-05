{-# LANGUAGE OverloadedStrings #-}

{-
    Run this example by doing:

    $ stack runghc -- -ilib:examples examples/MuppetShow/Episode.hs

    or similar.
-}

module MuppetShow.Episode where

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

