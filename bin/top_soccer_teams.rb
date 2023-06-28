#!/usr/bin/env ruby
require_relative "../lib/game_results_processor"

if $PROGRAM_NAME == __FILE__
  input_stream = ARGF
  GameResultsProcessor.new.process_results(input_stream)
end
