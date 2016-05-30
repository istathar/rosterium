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


main :: IO ()
main = do
    vs <- withSystemRandom . asGenIO $ \gen -> uniformVector gen 3 :: IO (Vector Word8)
    print vs

hourglass :: IO ()
hourglass = do
    now <- timeCurrentP
    print $ timeGetDateTimeOfDay now
