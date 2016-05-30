{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.ByteString.Lazy.Char8 as L
import Data.Text (Text)
import qualified Data.Text.IO as T
import Data.Hourglass
import Data.Vector
import Data.Word
import System.Random.MWC
import Time.System

import Rosterium.Allocatus
import Rosterium.Dealer


main :: IO ()
main = do
    vs <- withSystemRandom . asGenIO $ \gen -> shuffle gen [1,2,3,4]
    print vs

hourglass :: IO ()
hourglass = do
    now <- timeCurrentP
    print $ timeGetDateTimeOfDay now
