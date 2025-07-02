module Main where

import Sum

main :: IO ()
main = putStrLn $ "hello world! See magic 1 + 2 = " ++ show (magicSum 1 2)
