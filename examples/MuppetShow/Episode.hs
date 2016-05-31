{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

module MuppetShow.Episode where

import Data.List (intercalate)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T

import Rosterium.Allocatus
import MuppetShow.Cast

main :: IO ()
main = do
--  gen <- createSystemRandom
    gen <- initialize (V.singleton 3)
    available <- load performers gen
    roster <- allocate 13 available

    putStrLn $ intercalate "\n" $ fmap show . rosterPeople $ roster

