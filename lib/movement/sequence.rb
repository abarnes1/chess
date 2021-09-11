require_relative '../position_helpers'

# Defines the interface and common behavior for other Sequence types.
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

    offsets.each do |offset|
      new_position = calculate_position(start_position, offset)
      break if new_position.nil?

      positions << new_position
    end

    positions
  end
end

# Move.for(sequence)

# Move
#  - has start
#  - has end
#  - has next