# frozen_string_literal: true
require "stringio"
require "game_results_processor"

describe GameResultsProcessor do
  describe "#process_game_results" do
    describe "input validation" do
      let (:expected_output) do
        expected_output_file =
          File.expand_path("../fixtures/expected-output.txt", __FILE__)
        File.read(expected_output_file)
      end

      context "when input is valid" do
        it "processes valid lines" do
          valid_input_file =
            File.expand_path("../fixtures/valid-input.txt", __FILE__)
          ARGV.replace [valid_input_file]

          expect { GameResultsProcessor.new.process_results(ARGF) }.to output(
            expected_output,
          ).to_stdout
        end
      end

      context "when input contains invalid lines" do
        it "skip invalid lines and processes valid lines" do
          invalid_input_file =
            File.expand_path("../fixtures/invalid-input.txt", __FILE__)
          ARGV.replace [invalid_input_file]
          expect { GameResultsProcessor.new.process_results(ARGF) }.to output(
            expected_output,
          ).to_stdout
        end
      end
    end

    context "when the input data stream stopped in the middle of a match day" do
      context "and when the league is at matchday 1" do
        it "outputs the top teams to stdout " do
          interrupted_input = <<~INPUT
            Soccer Team A 1, Soccer Team B 1
            Soccer Team C 2, Soccer Team D 3
          INPUT
          expected_interrupted_output = <<~OUTPUT
            Matchday 1
            Soccer Team D, 3 pts
            Soccer Team A, 1 pt
            Soccer Team B, 1 pt
          OUTPUT
          input_stream = StringIO.new(interrupted_input)

          expect {
            GameResultsProcessor.new.process_results(input_stream)
          }.to output(expected_interrupted_output).to_stdout
        end
      end

      context "when the league is at any other matchday after matchday 1" do
        it "outputs the top teams to stdout " do
          interrupted_input_file =
            File.expand_path("../fixtures/interrupted-input.txt", __FILE__)
          ARGV.replace [interrupted_input_file]

          expected_interrupted_output_file =
            File.expand_path(
              "../fixtures/expected-interrupted-output.txt",
              __FILE__,
            )
          expected_interrupted_output =
            File.read(expected_interrupted_output_file)

          expect { GameResultsProcessor.new.process_results(ARGF) }.to output(
            expected_interrupted_output,
          ).to_stdout
        end
      end

      context "when there are only two teams in the league" do
        it "handles the situation that less than 3 teams will be displayed in the result" do
          interrupted_input = <<~INPUT
            Soccer Team A 1, Soccer Team B 1
            Soccer Team B 3, Soccer Team A 1
          INPUT
          expected_interrupted_output = <<~OUTPUT
            Matchday 1
            Soccer Team A, 1 pt
            Soccer Team B, 1 pt

            Matchday 2
            Soccer Team B, 4 pts
            Soccer Team A, 1 pt
          OUTPUT
          input_stream = StringIO.new(interrupted_input)

          expect {
            GameResultsProcessor.new.process_results(input_stream)
          }.to output(expected_interrupted_output).to_stdout
        end
      end
    end
  end
end
