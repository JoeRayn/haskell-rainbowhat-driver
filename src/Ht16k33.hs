module Ht16k33 (
    setBrightness
  , writeSingleByte
  , writeDisplayBuffer
  , entireDisplayBuffer
  , blink2Hz
  , blinkOff
  , blink1Hz
  , blinkHalfHz
  , displayOn
  , displayOff
  , displaySetup
  , oscillatorOff
  , oscillatorOn
  , systemSetup
  )
where

import System.RaspberryPi.GPIO
import Control.Monad
import Control.Monad.State
import Data.Word
import Data.Array
import Data.List
import qualified Data.ByteString as BS
import Data.Bits
import Control.Concurrent
import Data.Word

address :: Address
address = 0x70

newtype BlinkFreq = BlinkFreq { getWord8 :: Word8}
 deriving (Eq,Show)

blinkOff = BlinkFreq 0x00
blink2Hz = BlinkFreq 0x02
blink1Hz = BlinkFreq 0x04
blinkHalfHz = BlinkFreq 0x06

newtype DisplayStatus = DisplayStatus { getWord :: Word8}
 deriving (Show)
displayOn = DisplayStatus 0x01
displayOff = DisplayStatus 0x00

displaySetupCmd = 0x80
systemSetupCmd = 0x20
brightnessCmd = 0xE0

newtype OscillatorStatus = OscillatorStatus {getVal :: Word8}
 deriving (Show)
oscillatorOn = OscillatorStatus 0x01
oscillatorOff = OscillatorStatus 0x00

displaySetup :: DisplayStatus -> BlinkFreq -> DisplayBuffer ()
displaySetup s b = writeSingleByte (displaySetupCmd .|. getWord s .|. getWord8 b) 

systemSetup :: OscillatorStatus -> DisplayBuffer ()
systemSetup s = writeSingleByte (systemSetupCmd .|. getVal s)

type DisplayBufferState = [Word8]
type DisplayBuffer = StateT DisplayBufferState IO

--write a single byte, useful for setting brightness, turning on oscillator, etc
writeSingleByte :: Word8 -> DisplayBuffer ()
writeSingleByte w = liftIO $ writeI2C address (BS.singleton w)

setBrightness :: Word8 -> DisplayBuffer ()
setBrightness b
    | (b > 15)  = go 15
    | otherwise = go b
    where go x = writeSingleByte (brightnessCmd .|. x)

shortDelay :: DisplayBuffer ()
shortDelay = liftIO $ threadDelay 200000

entireDisplayBuffer :: Word8 -> DisplayBufferState
entireDisplayBuffer c = replicate 16 c
-- entireDisplayBuffer c = array (0,15) [(x, c)| x <- [0..15]]

writeDisplayBuffer :: DisplayBuffer ()
writeDisplayBuffer = do
    displayBufferState <- get
    liftIO $ writeI2C address (toI2cWords displayBufferState)

-- 0x00 is the location in ram to start writing (I think) we always use it as we always write the full 16 bytes
toI2cWords :: DisplayBufferState -> BS.ByteString
toI2cWords s = BS.pack $ 0x00 : s

turnOff :: DisplayBuffer ()
turnOff = do writeSingleByte 0x20
             writeSingleByte 0x80
