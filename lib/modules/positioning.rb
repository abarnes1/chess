# frozen_string_literal: true

require_relative '../position'
require_relative '../movement/offset'
require_relative '../movement/repeat_offset'

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

  def calculate_sequences(position, offsets)
    p offsets
    return [] if offsets.nil?

    sequences = []

    offsets.each do |offset|
      sequence = calculate_single_sequence(position, offset)
      sequences << sequence unless sequence.empty?
    end

    sequences
  end

  def calculate_single_sequence(position, offset)
    return [] if offset.nil?

    sequence = []
    max_repeats = offset.is_a?(RepeatOffset) ? offset.max_repeats : 1
    current_position = position

    max_repeats.times do
      current_position = next_position(current_position, offset)

      break if current_position.nil?

      sequence << current_position
    end

    sequence
  end

  private

  def calculate_rank(rank, y_offset)
    (rank.to_i + y_offset).to_s
  end

  def calculate_file(file, x_offset)
    (file.ord + x_offset).chr
  end
end
