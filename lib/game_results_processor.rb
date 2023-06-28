require_relative "./league"

class GameResultsProcessor
  GAME_RESULT_REGEX = /\A\s*([A-Za-z\s]+)\s+(\d+),\s+([A-Za-z\s]+)\s+(\d+)\s*\z/
  def initialize()
    @league = League.new
  end

  def process_results(input_stream)
    input_stream.each_line { |result| process_result result }
    handle_interruption if interrupted?
  end

  private

  def process_result(result)
    if valid_result?(result)
      parsed_result = parse_result(result)
      @league.add_result(parsed_result)
    end
  end

  def valid_result?(result)
    return GAME_RESULT_REGEX.match?(result)
  end

  def parse_result(result)
    match = result.match(GAME_RESULT_REGEX)
    return(
      {
        home_team: match[1],
        home_score: match[2].to_i,
        away_team: match[3],
        away_score: match[4].to_i,
      }
    )
  end

  ##
  # Treat input streams as interrupted
  #   if it stopped at matchday 1
  #     or
  #   if the end of current matchday is not reached
  def interrupted?
    @league.matchday == 1 || @league.matchday_matches > 0
  end

  def handle_interruption
    @league.output_top_teams
  end
end
