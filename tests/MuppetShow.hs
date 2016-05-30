{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

module Main where

import Data.List (intercalate)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Data.Hourglass
import qualified Data.Vector as V
import System.Random.MWC
import Time.System

import Rosterium.Allocatus

type Name = Text
type Handle = Text

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
    show Stunts  = "is a self-reflexive Stunt double"
    show Instrument = "plays an Instrument"

instance Skill Talent where
    skill x = T.pack . show $ x

data Muppet = Muppet Name Handle Role [Talent]

instance Show Muppet where
    show (Muppet nom nick role talents) = T.unpack nom
        ++ " (" ++ T.unpack nick ++ "); a "
        ++ show role ++ " who " ++
        if null talents
            then "has no talent"
            else intercalate ", " (fmap show talents)


instance Person Muppet where
    name (Muppet nom _ _ _) = nom
    handle (Muppet _ nick _ _) = nick


performers :: [Muppet]
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
--  gen <- createSystemRandom
    gen <- initialize (V.singleton 3)
    available <- load performers gen
    roster <- allocate 13 available

    putStrLn $ intercalate "\n" $ fmap show . rosterPeople $ roster
