# frozen_string_literal: true

# represents a file-first position on a chessboard: a1, h8, etc
class Position
  attr_reader :rank, :file

  def initialize(position)
    @file = position[0] # numerical/row
    @rank = position[1] # alpha/column
  end

  def position
    @file + @rank
  end

  def ==(other)
    # p 'equality!'
    other.position == position
  end

  def to_s
    position
  end

  # def to_i
  # end
end