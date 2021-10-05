# frozen_string_literal: true

# Represents a single [x, y] coordinate move.
class Offset
  attr_reader :x, :y

  def initialize(coordinate)
    @x = coordinate[0]
    @y = coordinate[1]
  end

  def ==(other)
    return false if other.nil?

    x == other.x && y == other.y
  end
end
