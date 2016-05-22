module Rosterium.Setup where

import Rosterium.Types
import Data.Sequence (Seq)
import qualified Data.Sequence as Seq

--
-- | The index into the list of people where we next resume populating the roster
--

seed :: Int
seed = undefined


load :: Person a => [a] -> Seq a
load = Seq.fromList
