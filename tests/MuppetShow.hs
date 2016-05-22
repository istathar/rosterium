{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

module Main where

import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as S
import Data.List (intercalate)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Data.Hourglass
import Time.System

import Roster.Setup
import Roster.Types

data Role = StageHand | Supporting | Main | Producer | Owner
    deriving (Eq, Enum, Ord)

instance Show Role where
    show StageHand  = "Stage Hand"
    show Supporting = "Supporting Character"
    show Main       = "Main Character"
    show Producer   = "Producer of the Show"
    show Owner      = "Owner of the Theatre"


instance Grade Role where
    grade x = T.pack . show $ x

data Talent = Sings | Dances | Comedy | Stunts | Instrument

instance Show Talent where
    show Sings   = "Sings"
    show Dances  = "Dances"
    show Comedy  = "does Comedy"
    show Stunts  = "is a Self Reflexive Stunt Double"
    show Instrument = "plays an Instrument"


data Muppet = Muppet Text ByteString Role [Talent]

instance Show Muppet where
    show (Muppet name handle role talents) = T.unpack name
        ++ " (" ++ S.unpack handle ++ "); a "
        ++ show role ++ " who " ++ intercalate ", " (fmap show talents)


performers =
    [ Muppet "Kermit the Frog" "kermit" Producer [Sings, Comedy]
    , Muppet "Miss Piggy" "piggy" Main [Sings, Dances, Comedy]
    , Muppet "Fozzie Bear" "fozzie" Main [Comedy]
    , Muppet "Gonzo the Great" "gonzo88" Main [Stunts]
    , Muppet "Rowlf the Dog" "rowlf" Main [Sings, Comedy, Instrument]
    , Muppet "Janice, Lead Guitar" "janice" Supporting [Instrument]
    , Muppet "Dr. Teeth" "dr_teeth" Supporting [Sings, Instrument]
    , Muppet "The Swedish Chef" "imnotswedish" Supporting [Comedy]
    , Muppet "Beaker" "beaker" Supporting [Stunts]
    , Muppet "Dr. Busnen Honeydew" "MadScientist" Supporting [Comedy]
    , Muppet "Scooter" "scooter" StageHand []
    , Muppet "Scooter's Uncle" "miser" Owner []
    ]


main :: IO ()
main = do
    putStrLn $ intercalate "\n" $ fmap show $ take 5 $ performers
