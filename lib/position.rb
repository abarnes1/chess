# frozen_string_literal: true

# represents a file-first position on a chessboard: a1, h8, etc
class Position
  attr_reader :rank, :file

  def initialize(position)
    @file = position[0].downcase # alpha column
    @rank = position[1] # numerical row
  end

  def position
    @file + @rank
  end

  def ==(other)
    return false if other.nil?

    other.position == position
  end

  def to_s
    position
  end

  def inbounds?
    return false if file.nil? || rank.nil?

    ('a'..'h').include?(file) && ('1'..'8').include?(rank)
  end
end
