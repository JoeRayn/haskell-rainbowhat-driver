module Main where

import Control.Concurrent
import Control.Monad
import System.RaspberryPi.GPIO
import Data.Word
import Ht16k33
-- import System.Hardware.WiringPi
import Data.List
import Led
import Control.Monad.State
-- import Apa102

-- main :: IO ()
main = withGPIO . withI2C . (flip evalStateT (entireDisplayBuffer 0x00)) $ do
    writeSingleByte 0x20 -- switches on the internal oscillator of the LED backpack
    writeSingleByte 0x80 -- turns on display, sets blink rate to "not blinking"
    -- writeSingleByte 0xEF -- sets brightness to maximum 
    -- put $ entireDisplayBuffer 0x00
    -- shortDelay
    -- writeDisplayBuffer
    -- shortDelay
    -- modify (\x ->  [0x3E, 0x05])--switches all pixels to Off
    -- shortDelay 
    -- writeDisplayBuffer
        --fill up the entire array pixel by pixel, waiting a bit after each one
        --some wild multicolor stuff
        -- a bit of dimming
    -- forever $ forM_ leds $ \x -> do
     --     digitalWrite x HIGH
     --     threadDelay 20000
     --     threadDelay 20000
     --     digitalWrite x LOW
     

