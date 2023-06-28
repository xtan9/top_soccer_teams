require_relative "./league"

class Team
  attr_reader :points
  attr_reader :name

  def initialize(name)
    @name = name
    @points = 0
  end

  def add_points(points)
    if valid_points?(points)
      @points += points
    else
      raise ArgumentError, "Invalid points: #{points}"
    end
  end

  def <=>(other)
    result = other.points <=> points
    result.zero? ? name <=> other.name : result
  end

  private

  def valid_points?(points)
    League::POINTS.values.include?(points)
  end
end
