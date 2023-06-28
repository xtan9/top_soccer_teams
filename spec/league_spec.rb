# frozen_string_literal: true
require "league"
require "stringio"
require "rspec/expectations"

describe League do
  describe "#add_result" do
    context "when it's match day 1" do
      let(:league) do
        game_results = [
          {
            home_team: "Soccer Team A",
            home_score: 0,
            away_team: "Soccer Team B",
            away_score: 0,
          },
          {
            home_team: "Soccer Team C",
            home_score: 5,
            away_team: "Soccer Team D",
            away_score: 3,
          },
          {
            home_team: "Soccer Team E",
            home_score: 0,
            away_team: "Soccer Team F",
            away_score: 3,
          },
        ]
        league = League.new
        game_results.each { |result| league.add_result result }
        league
      end

      it "calculates points earned by each team" do
        expect(league.teams).to include(
          "Soccer Team A" => be_a(Team).and(have_attributes(points: 1)),
          "Soccer Team B" => be_a(Team).and(have_attributes(points: 1)),
          "Soccer Team C" => be_a(Team).and(have_attributes(points: 3)),
          "Soccer Team D" => be_a(Team).and(have_attributes(points: 0)),
          "Soccer Team E" => be_a(Team).and(have_attributes(points: 0)),
          "Soccer Team F" => be_a(Team).and(have_attributes(points: 3)),
        )
      end
      it "knows matchday infomation" do
        expect(league.matchday).to eq(1)
        expect(league.matchday_matches).to eq(3)
      end
    end

    context "When it's match day 2 and after" do
      before(:all) do
        game_results = [
          {
            home_team: "Soccer Team A",
            home_score: 0,
            away_team: "Soccer Team B",
            away_score: 0,
          },
          {
            home_team: "Soccer Team C",
            home_score: 5,
            away_team: "Soccer Team D",
            away_score: 3,
          },
          {
            home_team: "Soccer Team A",
            home_score: 0,
            away_team: "Soccer Team C",
            away_score: 3,
          },
          {
            home_team: "Soccer Team B",
            home_score: 2,
            away_team: "Soccer Team D",
            away_score: 3,
          },
          {
            home_team: "Soccer Team A",
            home_score: 3,
            away_team: "Soccer Team D",
            away_score: 1,
          },
          {
            home_team: "Soccer Team B",
            home_score: 2,
            away_team: "Soccer Team C",
            away_score: 1,
          },
        ]
        original_stdout = $stdout
        $stdout = StringIO.new
        @league = League.new
        game_results.each { |result| @league.add_result result }
        @output = $stdout.string
        $stdout = original_stdout
      end

      it "calculates points earned by each team" do
        expect(@league.teams).to include(
          "Soccer Team A" => be_a(Team).and(have_attributes(points: 4)),
          "Soccer Team B" => be_a(Team).and(have_attributes(points: 4)),
          "Soccer Team C" => be_a(Team).and(have_attributes(points: 6)),
          "Soccer Team D" => be_a(Team).and(have_attributes(points: 3)),
        )
      end

      it "detects the end of a matchday" do
        expect(@league.matchday).to eq(4)
        expect(@league.matchday_matches).to eq(0)
      end

      it "outputs result to stdout" do
        expected_output = <<~OUTPUT
          Matchday 1
          Soccer Team C, 3 pts
          Soccer Team A, 1 pt
          Soccer Team B, 1 pt

          Matchday 2
          Soccer Team C, 6 pts
          Soccer Team D, 3 pts
          Soccer Team A, 1 pt

          Matchday 3
          Soccer Team C, 6 pts
          Soccer Team A, 4 pts
          Soccer Team B, 4 pts
        OUTPUT
        expect(@output).to eq(expected_output)
      end
    end
  end
end
