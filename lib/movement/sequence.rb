require_relative '../position_helpers'
require_relative 'offset'

# A series of coordinate offsets used to calculate position
# to position movements for chess pieces.  Each offset coordinate
# is treated like an independent move and returned if valid.
class PositionSequence
  include PositionHelpers

  attr_reader :offsets, :start_position

  def initialize(start_position, offsets)
    @start_position = start_position
    @offsets = offsets
  end

  def positions
    return nil if offsets.nil?

    positions = []
    next_start_position = start_position

    offsets.each do |offset|
      new_position = calculate_position(start_position, offset)
      break if new_position.nil?

      next_start_position = new_position
      positions << new_position if valid_new_position?(new_position, positions)
    end

    positions
  end

  private

  def valid_new_position?(new_position, positions)
    if new_position == start_position || positions.include?(new_position)
      false
    else
      true
    end
  end
end

# test = Sequence.new(Position.new('c4'), [[1, 1], [-1, -1]])
# test = Sequence.new(Position.new('c4'), [[0, 1], [0, 2]])
# puts test.positions

offset_groups = [
  Offset.new([1, 1]),
  Offset.new([-1, -1])
]

test = Sequence.new(Position.new('c4'), offset_groups)
puts test.positions

