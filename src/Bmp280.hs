module Bmp280
where

import           Data.Bits
import qualified Data.ByteString         as BS
import           Data.Word
import           System.RaspberryPi.GPIO
address :: Address
address = 0x77

qnh = 1020

powerMode = 3
osrsT = 5
osrsP = 5
filterV = 4
tSB = 4
config = (tSB `shiftL` 5) .&. (filterV `shiftL` 2) :: Word8
ctrlMeas = (osrsT `shiftL`  5) + (osrsP `shiftL` 2) + powerMode :: Word8

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

-- setup :: IO(Maybe [Word8])
-- this is wrong the readI2C and writeI2C funtions do not take a register just the address like the python library I was basing this on. I think you need to first write the register and then read or write but I need to read up on the I2C protocall or look into the underling python implementation to see what it does with the register.
-- setup = do
--   if readI2C address register_chipid == BS.singleton 0x58
--     then
--        return Nothing
--     else
--        writeI2C address (BS.singleton register_softreset) (BS.singleton 0xB6)
--        return undefined

