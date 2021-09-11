require_relative '../position_helpers'

# A series of coordinate offsets used to calculate position
# to position movements for chess pieces.
class Sequence
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
      new_position = calculate_position(next_start_position, offset)
      break if new_position.nil?

      next_start_position = new_position
      positions << new_position
    end

    positions
  end
end
