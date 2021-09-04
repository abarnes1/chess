# frozen_string_literal: true

# represents a file-first position on a chessboard: a1, h8, etc
class Position
  attr_reader :rank, :file

  def initialize(position)
    @file = position[0] # alpha column
    @rank = position[1] # numerical row
  end

  def position
    @file + @rank
  end

  def ==(other)
    other.position == position
  end

  def to_s
    position
  end
end
