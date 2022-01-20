{-# LANGUAGE BinaryLiterals #-}
module Apa102 where

import System.RaspberryPi.GPIO
import Control.Concurrent
import Control.Monad
import Data.Bits
import qualified Data.ByteString as BS
import Data.Word

{- corisponds to gpio pin 8 -}
chipSelectPin = CS0

{- trasfer 1 byte on MOSI pin. This seem to be the one used in the python libary, corrisponds to GPIO pin 10 in python library -}
trasferMOSI = transferSPI

type Pixel = (Word8, Word8, Word8, Word8)

numPixels = 7
defaultBrightness = 1

pix ::  Word8 -> Word8 -> Word8 -> Pixel
pix r g b = (r, g, b, defaultBrightness)

red = pix 50 0 0
yellow = pix 50 50 0 
pink = pix 50 10 12
green = pix 0 50 0
purple = pix 50 0 50
orange = pix 50 22 0
blue = pix 0 0 50

rainbow :: [Pixel]
rainbow = [red, yellow, pink, green, purple, orange, blue]

runApa102 = withGPIO . withSPI $ do
  setUp
  writePixels rainbow


setUp :: IO ()
setUp = do
  chipSelectSPI chipSelectPin
  setChipSelectPolaritySPI CS0 False -- ChipSelect is active low for transaction
  setBitOrderSPI MSBFirst -- Copy a comment in online java tutorial, this is the MSBFirst is the default but thought I would make it explicet
  setDataModeSPI (True, False) -- mode2 apparently worked out by someone else by trail and error
  -- setClockDividerSPI Word16 -- clock speed should be 1Mhz dont know how to set that as a Word16. probally just 1000000. just leave it as default for now.

-- | 32 bits required at the start of the message frame
startFrame :: [Word8]
startFrame = replicate 4 0
  
endFrame :: [Word8]
endFrame = replicate 5 0 -- atleast 36 bits

-- | Wrap Pixels in a frame and send to LED strip to be displayed, I need to check if this will ever raise an exception. 
writePixels :: [Pixel] -> IO ()
writePixels xs = transferManySPI (startFrame ++ dataFrame ++ endFrame) >> return ()
  where dataFrame = concat $ map pixel2Bytes xs

pixel2Bytes :: Pixel -> [Word8]
pixel2Bytes (red, green, blue, brightness) = [ 0b11100000 .|. brightness, blue, green ,red] 






