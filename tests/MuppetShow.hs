{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS -fno-warn-unused-imports #-}

module Main where

import Data.List (intercalate)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Data.Hourglass
import Text.Render
import Time.System

import Rosterium.Allocatus

type Name = Text
type Handle = Text

data Role = StageHand | Supporting | Main | Producer | Owner
    deriving (Eq, Enum, Ord)

instance Render Role where
    render StageHand  = "Stage Hand"
    render Supporting = "Supporting Character"
    render Main       = "Main Character"
    render Producer   = "Producer of the Show"
    render Owner      = "Owner of the Theatre"


instance Grade Role where
    grade x = render x

data Talent = Sings | Dances | Comedy | Stunts | Instrument

instance Render Talent where
    render Sings   = "Sings"
    render Dances  = "Dances"
    render Comedy  = "does Comedy"
    render Stunts  = "is a self-reflexive Stunt double"
    render Instrument = "plays an Instrument"

instance Skill Talent where
    skill x = render x

data Muppet = Muppet Name Handle Role [Talent]

instance Render Muppet where
    render (Muppet nom nick role talents) = T.concat
        [ nom
        , " (@" , nick , "); a "
        , render role
        , " who "
        , if null talents
            then "has no talent"
            else T.intercalate ", " (fmap render talents)
        ]


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
    let available = load performers 356928418652
    T.putStrLn $ T.intercalate "\n" $ fmap render . rosterPeople $ allocate 24 available
