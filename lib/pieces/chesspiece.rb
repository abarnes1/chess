# frozen_string_literal: true
require_relative '../movement/offset'
require_relative '../movement/repeat_offset'

class ChessPiece
  attr_reader :position, :offsets, :algebraic_letter, :owner

  def initialize(icon: 'X', owner: nil, position: nil, offsets: nil)
    @icon = icon.freeze
    @position = position
    @offsets = offsets
    @notation_letter = 'X'
    @owner = owner
  end

  def to_s
    @icon
  end
end
