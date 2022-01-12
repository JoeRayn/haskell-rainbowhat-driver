module Bmp280 
where

import System.RaspberryPi.GPIO
import Data.Bits
import Data.Word

address :: Address
address = 0x77

powerMode = 3
osrsT = 5
osrsP = 5
filter = 4
tSB = 4
config = (tSB `shiftL` 5) .&. (filter `shiftL` 2)                
ctrlMeas = (osrsT `shiftL`  5) + (osrsP `shiftL` 2) + prowerMode


register_dig_t1 = 0x88
register_dig_t2 = 0x8a
register_dig_t3 = 0x8c
register_dig_p1 = 0x8e
register_dig_p2 = 0x90
register_dig_p3 = 0x92
register_dig_p4 = 0x94
register_dig_p5 = 0x96
register_dig_p6 = 0x98
register_dig_p7 = 0x9a
register_dig_p8 = 0x9c
register_dig_p9 = 0x9e
register_chipid = 0xd0
register_version = 0xd1
register_softreset = 0xe0
register_control = 0xf4
register_config = 0xf5
register_status = 0xf3
register_tempdata_msb = 0xfa
register_tempdata_lsb = 0xfb
register_tempdata_xlsb = 0xfc
register_pressdata_msb = 0xf7
register_pressdata_lsb = 0xf8
register_pressdata_xlsb = 0xf9

setup :: IO([Word8])
setup = do writeI2C address register_softreset (BS.singleton 0xB6)
           
            
