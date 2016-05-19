{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

module Main where

import qualified Data.ByteString.Lazy.Char8 as L
import Data.Text (Text)
import qualified Data.Text.IO as T
import Data.Hourglass
import Time.System

import Roster.Setup

main :: IO ()
main = do
    now <- timeCurrentP
    print $ timeGetDateTimeOfDay now
