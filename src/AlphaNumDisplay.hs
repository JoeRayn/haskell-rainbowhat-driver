{-# LANGUAGE BinaryLiterals #-}
module AlphaNumDisplay (lookupChar) where

import           Control.Concurrent
import           Control.Monad
import           Control.Monad.State
import           Data.Bits
import           Data.Maybe
import           Data.Time.Format
import           Data.Time.LocalTime
import           Data.Word
import           Ht16k33
import           System.RaspberryPi.GPIO

data Pos = A | B | C | D
  deriving (Show)

lookupChar :: Char -> Word16
lookupChar c = fromMaybe 0x0000 (lookup c charMap)

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

charMap :: [(Char, Word16)]
charMap = [(' ', 0b0000000000000000),
    ('!', 0b0000000000000110),
    ('"', 0b0000001000100000),
    ('#', 0b0001001011001110),
    ('$', 0b0001001011101101),
    ('%', 0b0000110000100100),
    ('&', 0b0010001101011101),
    ('\'', 0b0000010000000000),
    ('(', 0b0010010000000000),
    (')', 0b0000100100000000),
    ('*', 0b0011111111000000),
    ('+', 0b0001001011000000),
    (',', 0b0000100000000000),
    ('-', 0b0000000011000000),
    ('.', 0b0000000000000000),
    ('/', 0b0000110000000000),
    ('0', 0b0000110000111111),
    ('1', 0b0000000000000110),
    ('2', 0b0000000011011011),
    ('3', 0b0000000010001111),
    ('4', 0b0000000011100110),
    ('5', 0b0010000001101001),
    ('6', 0b0000000011111101),
    ('7', 0b0000000000000111),
    ('8', 0b0000000011111111),
    ('9', 0b0000000011101111),
    (':', 0b0001001000000000),
    (';', 0b0000101000000000),
    ('<', 0b0010010000000000),
    ('=', 0b0000000011001000),
    ('>', 0b0000100100000000),
    ('?', 0b0001000010000011),
    ('@', 0b0000001010111011),
    ('A', 0b0000000011110111),
    ('B', 0b0001001010001111),
    ('C', 0b0000000000111001),
    ('D', 0b0001001000001111),
    ('E', 0b0000000011111001),
    ('F', 0b0000000001110001),
    ('G', 0b0000000010111101),
    ('H', 0b0000000011110110),
    ('I', 0b0001001000000000),
    ('J', 0b0000000000011110),
    ('K', 0b0010010001110000),
    ('L', 0b0000000000111000),
    ('M', 0b0000010100110110),
    ('N', 0b0010000100110110),
    ('O', 0b0000000000111111),
    ('P', 0b0000000011110011),
    ('Q', 0b0010000000111111),
    ('R', 0b0010000011110011),
    ('S', 0b0000000011101101),
    ('T', 0b0001001000000001),
    ('U', 0b0000000000111110),
    ('V', 0b0000110000110000),
    ('W', 0b0010100000110110),
    ('X', 0b0010110100000000),
    ('Y', 0b0001010100000000),
    ('Z', 0b0000110000001001),
    ('[', 0b0000000000111001),
    ('\\', 0b0010000100000000),
    (']', 0b0000000000001111),
    ('^', 0b0000110000000011),
    ('_', 0b0000000000001000),
    ('`', 0b0000000100000000),
    ('a', 0b0001000001011000),
    ('b', 0b0010000001111000),
    ('c', 0b0000000011011000),
    ('d', 0b0000100010001110),
    ('e', 0b0000100001011000),
    ('f', 0b0000000001110001),
    ('g', 0b0000010010001110),
    ('h', 0b0001000001110000),
    ('i', 0b0001000000000000),
    ('j', 0b0000000000001110),
    ('k', 0b0011011000000000),
    ('l', 0b0000000000110000),
    ('m', 0b0001000011010100),
    ('n', 0b0001000001010000),
    ('o', 0b0000000011011100),
    ('p', 0b0000000101110000),
    ('q', 0b0000010010000110),
    ('r', 0b0000000001010000),
    ('s', 0b0010000010001000),
    ('t', 0b0000000001111000),
    ('u', 0b0000000000011100),
    ('v', 0b0010000000000100),
    ('w', 0b0010100000010100),
    ('x', 0b0010100011000000),
    ('y', 0b0010000000001100),
    ('z', 0b0000100001001000),
    ('{', 0b0000100101001001),
    ('|', 0b0001001000000000),
    ('}', 0b0010010010001001),
    ('~', 0b0000010100100000)]

