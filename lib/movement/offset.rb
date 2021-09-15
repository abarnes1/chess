# frozen_string_literal: true

# Represents a single [x, y] coordinate move.
class Offset
  attr_reader :x, :y

  def initialize(coordinate)
    @x = coordinate[0]
    @y = coordinate[1]
  end

  def out_of_range?
    x.abs >= 8 || y.abs >= 8
  end
end
