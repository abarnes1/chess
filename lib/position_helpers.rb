# frozen_string_literal: true

require_relative 'position'

# Helper functions that are used throughout the chess game, including
# the various pieces, to calculate moves and determine if they are
# inside the bounds of a normal chessboard.
module PositionHelpers
  def inbounds?(position)
    return nil unless position.instance_of?(Position)

    ('a'..'h').include?(position.file) && ('1'..'8').include?(position.rank)
  end

  def calculate_position(position, offset)
    return nil if offset.any? { |move| move.abs >= 8 }

    new_position = Position.new(calculate_file(position.file, offset[0]) + calculate_rank(position.rank, offset[1]))

    inbounds?(new_position) ? new_position : nil
  end

  private

  def calculate_rank(rank, y_offset)
    (rank.to_i + y_offset).to_s
  end

  def calculate_file(file, x_offset)
    (file.ord + x_offset).chr
  end
end
