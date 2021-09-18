# frozen_string_literal: true

require_relative '../position'
require_relative '../movement/offset'

# Helper functions that are used throughout the chess game, including
# the various pieces, to calculate moves and determine if they are
# inside the bounds of a normal chessboard.
module Positioning
  def next_position(position, offset)
    return nil if position.nil?

    # return nil if offset.nil? || offset.out_of_range?

    new_position = Position.new(calculate_file(position.file, offset.x) + calculate_rank(position.rank, offset.y))
    new_position.inbounds? ? new_position : nil
  end

  private

  def calculate_rank(rank, y_offset)
    (rank.to_i + y_offset).to_s
  end

  def calculate_file(file, x_offset)
    (file.ord + x_offset).chr
  end
end
