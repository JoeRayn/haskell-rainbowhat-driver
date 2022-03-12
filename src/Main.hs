module Main where

import qualified Data.ByteString as BS
import           AlphaNumDisplay
import           Apa102
import           Bmp280

-- once everything is working I think Im going to need to use some concurrency here to get
-- everything to run at the same time, good thing I watched that lecture series
main :: IO ()
main = do
   runApa102
   bmp_setup
   -- runClock 
