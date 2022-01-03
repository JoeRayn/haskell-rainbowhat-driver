module Ht16k33 where

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

ht16k33_blink_cmd = 0x80
ht16k33_blink_displayon = 0x01
ht16k33_blink_off = 0x00
ht16k33_blink_2hz = 0x02
ht16k33_blink_1hz = 0x04
ht16k33_blink_halfhz = 0x06

ht16k33_system_setup = 0x20
ht16k33_oscillaor = 0x01
ht16k33_cmd_brightness = 0xe0

type DisplayBufferState = [Word8]
type DisplayBuffer = StateT DisplayBufferState IO

--write a single byte, useful for setting brightness, turning on oscillator, etc
writeSingleByte :: Word8 -> DisplayBuffer ()
writeSingleByte w = liftIO $ writeI2C address (BS.singleton w)

setBrightness :: Word8 -> DisplayBuffer ()
setBrightness b
    | (b > 15)  = go 15
    | otherwise = go b
    where go x = writeSingleByte (0xE0 .|. x) --0xEX is the magic word for brightness

shortDelay :: DisplayBuffer ()
shortDelay = liftIO $ threadDelay 200000

entireDisplayBuffer :: Word8 -> DisplayBufferState
entireDisplayBuffer c = replicate 16 c
-- entireDisplayBuffer c = array (0,15) [(x, c)| x <- [0..15]]

writeDisplayBuffer :: DisplayBuffer ()
writeDisplayBuffer = do
    displayBufferState <- get
    liftIO $ writeI2C address (toI2cWords displayBufferState)


toI2cWords :: DisplayBufferState -> BS.ByteString
toI2cWords s = BS.pack $ 0x00 : s
