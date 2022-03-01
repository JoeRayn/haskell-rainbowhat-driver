module Main where

import qualified Data.ByteString as BS
import           AlphaNumDisplay
import           Apa102
import           Bmp280


main :: IO ()
main = do
   bmp_setup
