# frozen_string_literal: true
require_relative '../movement/offset'
require_relative '../movement/repeat_offset'

class ChessPiece
  attr_reader :position, :offsets, :algebraic_letter

  def initialize(icon: 'X', position: nil, offsets: nil)
    @icon = icon.freeze
    @position = position
    @offsets = offsets
    @notation_letter = 'X'
  end

  def to_s
    @icon
  end
end
