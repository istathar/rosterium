{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

module Main where

import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as S
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Data.Hourglass
import Time.System

import Roster.Setup
import Roster.Types

data Role = StageHand | SupportingCharacter | MainCharacter | Producer | Owner
    deriving (Show, Eq, Enum, Ord)

instance Grade Role where
    grade x = T.pack . show $ x

data Muppet = Muppet Text ByteString Role

instance Show Muppet where
    show (Muppet name _ _) = T.unpack name


performers =
   [Muppet "Kermit the Frog" "kermit" Producer,
    Muppet "Miss Piggy" "piggy" MainCharacter,
    Muppet "Fozzie Bear" "fozzie" MainCharacter,
    Muppet "Gonzo the Great" "gonzo88" MainCharacter,
    Muppet "Rowlf the Dog" "rowlf" MainCharacter,
    Muppet "Janice, Lead Guitar" "janice" SupportingCharacter,
    Muppet "Dr. Teeth" "dr_teeth" SupportingCharacter,
    Muppet "The Swedish Chef" "imnotswedish" SupportingCharacter,
    Muppet "Beaker" "beaker" SupportingCharacter,
    Muppet "Dr. Busnen Honeydew" "MadScientist" SupportingCharacter,
    Muppet "Scooter" "scooter" StageHand,
    Muppet "Scooter's Uncle" "miser" Owner]


main :: IO ()
main = do
    print . take 5 $ performers
