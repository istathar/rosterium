module Rosterium.Allocate where

import Data.Sequence (Seq)
import qualified Data.Sequence as Seq
import Data.Foldable

import Rosterium.Types

allocate :: Int -> Seq a -> [a]
allocate count avail = toList $ Seq.take count avail


allocate :: Int -> Seq a -> Seq a
allocate = Seq.take

