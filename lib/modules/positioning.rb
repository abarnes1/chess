# frozen_string_literal: true

require_relative '../position'
require_relative '../movement/offset'

# Helper functions that are used throughout the chess game, including
# the various pieces, to calculate moves and determine if they are
# inside the bounds of a normal chessboard.
module Positioning
  def position_sequences(position, offsets)
    position_sequences = []

    offsets.each do |offset|
      position_sequences << if offset.repeat?
                              position_chain(position, offset)
                            else
                              [] << next_position(position, offset)
                            end
    end

    clean(position_sequences)
  end

  def next_position(position, offset)
    return nil if position.nil?
    return nil if offset.nil? || offset.out_of_range?

    new_position = Position.new(calculate_file(position.file, offset.x) + calculate_rank(position.rank, offset.y))

    new_position.inbounds? ? new_position : nil
  end

  def position_chain(start_position, repeating_offset)
    positions = []

    current_position = start_position

    until current_position.nil? || !current_position.inbounds?
      current_position = next_position(current_position, repeating_offset)
      break if current_position.nil? || !current_position.inbounds?

      positions << current_position
      break unless repeating_offset.repeat?
    end

    positions
  end

  private

  def calculate_rank(rank, y_offset)
    (rank.to_i + y_offset).to_s
  end

  def calculate_file(file, x_offset)
    (file.ord + x_offset).chr
  end

  def clean(sequences)
    sequences.compact.delete_if { |sequence| sequence.all?(nil) || sequence.empty? }
  end
end
