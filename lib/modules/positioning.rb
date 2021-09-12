# frozen_string_literal: true

require_relative '../position'
require_relative '../movement/offset'

# Helper functions that are used throughout the chess game, including
# the various pieces, to calculate moves and determine if they are
# inside the bounds of a normal chessboard.
module Positioning
  # def inbounds?(position)
  #   return nil unless position.instance_of?(Position)

  #   ('a'..'h').include?(position.file) && ('1'..'8').include?(position.rank)
  # end

  def position_sequences(position, offsets)
    position_sequences = []

    offsets.each do |offset|
      position_sequences << if offset.repeat?
                              position_chain(position, offset)
                            else
                              [] << next_position(position, offset)
                            end
    end

    position_sequences
  end

  def next_position(position, offset)
    return nil if position.nil?
    return nil if offset.nil? || offset_out_of_range?(offset)

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

  def offset_out_of_range?(offset)
    offset.x.abs >= 8 || offset.y.abs >= 8
  end
end

class TestClass
  include Positioning
end

pos = Position.new('a1')
offsets_a = [
  Offset.new([1, 1]),
  Offset.new([2, 0])
]

test = TestClass.new

sequences = test.position_sequences(pos, offsets_a)
sequences.each do |item|
  puts "sequence of class: #{item.class} -> #{item.join(' | ')}"
end

offsets_b = [
  Offset.new([1, 1], repeat: true),
  Offset.new([2, 0])
]
pos = Position.new('a1')
puts test.position_sequences(pos, offsets_b).join(' | ')

sequences = test.position_sequences(pos, offsets_b)
sequences.each do |item|
  puts "sequence of class: #{item.class} -> #{item.join(' | ')}"
end