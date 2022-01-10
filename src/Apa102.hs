module Apa102 where

import System.RaspberryPi.GPIO
import Control.Concurrent
import Control.Monad
import Data.Bits
import qualified Data.ByteString as BS
import Data.Word


-- ToDo read about the SPI https://learn.sparkfun.com/tutorials/serial-peripheral-interface-spi
-- the python seems to actually treat the them a normal GPIO pins and does not actually use the spi protocal i.e. manually pusling the clock. I dont think that is what real SPI should be however need to read more

{- corisponds to gpio pin 8 -}
chipSelectPin = CS0

{- trasfer 1 byte on MOSI pin. This seem to be the one used in the python libary, corrisponds to GPIO pin 10 in python library -}
trasferMOSI = transferSPI

-- I think we either need these GPIO pins or use the SPI function and pins but not both, in any case these value names now match (round abouts) the python library 
clockPin = Pin23
chipSelectPinGpio = Pin24
dataPin = Pin19



-- numPixels = 7
-- brightness = 7

-- pixels = replicate numPixels (0, 0, 0, brightness)

-- type Pixels = (Int, Int, Int, Double)

-- clear :: Pixels -> Pixels
-- clear (_, _, _, brightness) = (0, 0, 0, brightness)

runApa102 = withGPIO . withSPI $ do
  chipSelectSPI chipSelectPin

