{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

module Main where

import qualified Data.ByteString.Lazy.Char8 as L
import Data.Text (Text)
import qualified Data.Text.IO as T
import Data.Hourglass
import System.Random
import System.Random.Shuffle
import Time.System

import Rosterium.Setup


main :: IO ()
main = do
    gen <- newStdGen
    let input  = [1,2,3,4]
    let num = length input
    let result = shuffle' input num gen
    print result

hourglass :: IO ()
hourglass = do
    now <- timeCurrentP
    print $ timeGetDateTimeOfDay now
