# frozen_string_literal: true

# Helper functions that are used throughout the chess game, including
# the various pieces, to calculate moves and determine if they are
# inside the bounds of a normal chessboard.
module PositionHelpers
  def inbounds?(position)
    return nil unless position.instance_of?(String) && position.length == 2

    rank = position[0]
    file = position[1]

    ('a'..'h').include?(rank) && ('1'..'8').include?(file)
  end

  def calculate_position(position, offset)
    return nil if offset.any? { |move| move.abs >= 8 }

    new_position = calculate_rank(position[0], offset[0]) + calculate_file(position[1], offset[1])

    inbounds?(new_position) ? new_position : nil
  end

  private

  def calculate_rank(rank, x_offset)
    (rank.ord + x_offset).chr
  end

  def calculate_file(file, y_offset)
    (file.to_i + y_offset).to_s
  end
end
