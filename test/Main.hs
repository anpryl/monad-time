module Main (main) where

import           Control.Concurrent
import           Control.Monad.Reader
import           Control.Monad.State
import           Data.Time.Clock

import           Control.Monad.Time

main :: IO ()
main = do
  currentTime >>= print
  -- Test that generic MonadTrans instance works.
  runReaderT currentTime 'x' >>= print
  evalStateT (runReaderT currentTime 'x') 'y' >>= print
  -- Test that ReaderT UTCTime instance works
  now <- getCurrentTime
  runReaderT currentTime now >>= print

f :: (MonadTime m, MonadIO m) => m ()
f = do
    withConstantTime $ f2

f2 :: (MonadTime m, MonadIO m) => m ()
f2 = do
    now2 <- currentTime
    liftIO $ putStrLn $ show now2
    liftIO $ threadDelay (2000000)
    now3 <- currentTime
    liftIO $ putStrLn $ show now3
    liftIO $ threadDelay (2000000)
    now4 <- currentTime
    liftIO $ putStrLn $ show  now4
    liftIO $ putStrLn $ show $ all (now2 ==) [now2, now3, now4]
