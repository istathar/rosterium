module Rosterium.Setup where

import Data.Vector
import Data.Word
import System.Random.MWC

import Rosterium.Types

--
-- | The index into the list of people where we next resume populating the roster
--
load :: Person a => [a] -> Word32 -> IO (Bench a)
load persons seed = do
    gen <- initialize (singleton seed)
    return (Bench persons gen)
