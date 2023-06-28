require_relative "./team"

class League
  attr_reader :teams, :matchday, :matchday_matches

  POINTS = { win: 3, tie: 1, lose: 0 }
  TOP_N_TEAMS = 3

  def initialize
    @teams = {}
    @top_teams = []
    @matchday = 1
    @matchday_matches = 0
  end

  def add_result(result)
    # Determine the end of the matchday 1 by detecting the start of matchday 2
    if start_of_matchday_two?(result[:home_team], result[:away_team])
      output_top_teams
      start_new_matchday
    end
    update_team(result)
    # Print the top teams and start a new day when detects the end of the matchday.
    if end_of_matchday?
      output_top_teams
      start_new_matchday
    end
  end

  ##
  # Updates team points, calculates top 3 teams
  # and updates the match count of current matchday.
  def update_team(result)
    home_team = get_team(result[:home_team])
    away_team = get_team(result[:away_team])
    home_score = result[:home_score]
    away_score = result[:away_score]

    if home_score > away_score
      update_points(home_team, :win)
      update_points(away_team, :lose)
    elsif home_score < away_score
      update_points(away_team, :win)
      update_points(home_team, :lose)
    else
      update_points(home_team, :tie)
      update_points(away_team, :tie)
    end

    @matchday_matches += 1
  end

  def output_top_teams
    def team_info(team)
      points = team.points <= 1 ? "pt" : "pts"
      "#{team.name}, #{team.points} #{points}"
    end
    output = <<~OUTPUT
      #{"\n" if @matchday > 1}Matchday #{@matchday}
    OUTPUT
    @top_teams.each { |team| output += "#{team_info(team)}\n" }

    puts output
  end

  private

  def get_team(team_name)
    @teams[team_name] ||= Team.new(team_name)
  end

  def update_points(team, outcome)
    points = POINTS[outcome]
    team.add_points(points)
    update_top_teams(team) unless points == 0
  end

  def start_of_matchday_two?(team_name_1, team_name_2)
    @matchday == 1 &&
      (@teams.include?(team_name_1) || @teams.include?(team_name_2))
  end

  ##
  # Used to determine if the current matchday has ended.
  # Only applicable to matchday 2 or after.
  def end_of_matchday?
    max_matches = @teams.length / 2
    raise "Error: Too many matchday matches" if @matchday_matches > max_matches
    @matchday > 1 && @matchday_matches == max_matches
  end

  def start_new_matchday
    @matchday += 1
    @matchday_matches = 0
  end

  ##
  # Compare the newly updated team with existing top team.
  # Calculate the new top teams.
  # We sort at most 4 teams at a time, so the time complexity is O(1)
  def update_top_teams(team)
    @top_teams.push(team) unless @top_teams.include?(team)
    @top_teams = @top_teams.sort
    @top_teams.pop if @top_teams.length > TOP_N_TEAMS
  end
end
