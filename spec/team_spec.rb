# frozen_string_literal: true
require "team"

describe Team do
  let(:team_name) { "Soccer Team A" }
  let(:team) { Team.new(team_name) }

  describe "#add_points" do
    context "when valide points are provided" do
      it "adds points to the team" do
        expect(team.points).to eql(0)

        team.add_points(0)
        expect(team.points).to eql(0)

        team.add_points(1)
        expect(team.points).to eql(1)

        team.add_points(3)
        expect(team.points).to eql(4)
      end
    end
    context "when invalide points are provided" do
      it "raises an ArgumentError" do
        expect { team.add_points(2) }.to raise_error(
          ArgumentError,
          "Invalid points: 2",
        )
        expect { team.add_points(5) }.to raise_error(
          ArgumentError,
          "Invalid points: 5",
        )
        expect { team.add_points(-1) }.to raise_error(
          ArgumentError,
          "Invalid points: -1",
        )
      end
    end
  end
end
