module Main where

import Control.Concurrent
import Control.Monad
import System.RaspberryPi.GPIO
import Data.Word
import Data.Bits
import Ht16k33
import AlphaNumDisplay
-- import System.Hardware.WiringPi
import Data.List
import Led
import Control.Monad.State
import Data.Time.LocalTime
import Data.Time.Format
import Apa102


main :: IO ()
main = runApa102

runClock = withGPIO . withI2C . (flip evalStateT (entireDisplayBuffer 0x00)) $ do
    initDisplay 
    forever $ do
       now <- getCurrentTimeString
       put (encodeString now)
       liftIO $ threadDelay 1000000
       writeDisplayBuffer

getCurrentTimeString = do
    now <- liftIO $ getZonedTime
    return $ formatTime defaultTimeLocale "%H%M" now 

initDisplay = do   
    systemSetup oscillatorOn
    displaySetup displayOn blinkOff
    setBrightness 8
    writeDisplayBuffer

encodeWord16 :: Word16 -> [Word8]
encodeWord16 x = map fromIntegral [ x .&. 0xFF, (x .&. 0xFF00) `shiftR` 8 ]

encodeString :: String -> [Word8]
encodeString = concat . map encodeWord16 . fmap lookupChar

turnOffDisplay = do
  systemSetup oscillatorOff
  displaySetup displayOff blinkOff
