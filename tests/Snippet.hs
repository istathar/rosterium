{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module Main where

import qualified Data.ByteString.Lazy.Char8 as L
import Data.Text (Text)
import qualified Data.Text.IO as T
import Data.Hourglass
import Data.Word
import qualified Data.Vector as V
import System.Random.MWC
import Time.System

import Rosterium.Allocatus
import Rosterium.Dealer

main :: IO ()
main = do
    gen <- initialize (V.singleton 42)
    result <- allocateN 13 [5,6,7] [1,2,3,4] gen
    print result

basics :: IO ()
basics = do
    vs <- withSystemRandom . asGenIO $ \gen -> shuffle gen [1,2,3,4]
    print vs


hourglass :: IO ()
hourglass = do
    now <- timeCurrentP
    print $ timeGetDateTimeOfDay now
