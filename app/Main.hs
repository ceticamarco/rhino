module Main where

import Types (Args(..))
import Options.Applicative
    ( (<**>),
      fullDesc,
      header,
      help,
      info,
      long,
      metavar,
      progDesc,
      short,
      strOption,
      switch,
      execParser,
      helper,
      Parser )
import System.Exit (exitFailure)
import Paths_rhino (version)
import Data.Version (showVersion)
import Engine (checkPaths, convertFiles)

argsParser :: Parser Args
argsParser = Args
  <$> strOption
      ( long "src"
     <> short 's'
     <> metavar "SRC_DIR"
     <> help "Specify source directory" )
  <*> strOption
      ( long "output"
     <> short 'o'
     <> metavar "OUT_DIR"
     <> help "Specify output directory" )
  <*> strOption
      ( long "template"
     <> short 't'
     <> metavar "TEMPLATE"
     <> help "Specify template file" )
  <*> switch
      ( long "verbose"
     <> short 'v'
     <> help "Enable verbose mode" )

main :: IO ()
main = do
  args <- execParser opts
  -- Check whether directories and template exist
  checkPaths args >>= maybe (return ()) (\e -> putStrLn e >> exitFailure)
  -- Convert source files in the source directory to HTML pages
  convertFiles args >>= maybe (return ()) (\e -> putStrLn e >> exitFailure)
  where
    opts = info (argsParser <**> helper)
      ( fullDesc
     <> progDesc "rhino - markup language for building static websites"
     <> header ("rhino v" <> showVersion version <> " by Marco Cetica (c) 2025"))
