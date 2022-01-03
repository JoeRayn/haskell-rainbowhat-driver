module Apa102 where

import System.Hardware.WiringPi
import Data.List

dat = 10
clk = 11
cs = 8
numPixels = 7
brightness = 7

pixels = replicate numPixels (0, 0, 0, brightness)

type Pixels = (Int, Int, Int, Double)

clear :: Pixels -> Pixels
clear (_, _, _, brightness) = (0, 0, 0, brightness)
