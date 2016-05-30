{-# LANGUAGE OverloadedStrings #-}

module Main where

import Test.Hspec

import Rosterium.Allocatus

main :: IO ()
main = hspec suite

suite :: Spec
suite = do
    describe "Things" $ do
        it "can be done with stuff" $ do
            True `shouldBe` True
