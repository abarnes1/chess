# frozen_string_literal: true

require_relative 'offset'

# Represents a [x, y] coordinate move that can be repeated
# <n> times to form a sequence of positions.
class RepeatOffset < Offset
  attr_reader :max_repeats

  def initialize(coordinate, max_repeats = 100)
    super(coordinate)

    @max_repeats = max_repeats
  end

  def ==(other)
    return false if other.nil?

    x == other.x && y == other.y && max_repeats == other.max_repeats
  end
end
