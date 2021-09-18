# frozen_string_literal: true
require_relative '../movement/offset'
require_relative '../movement/repeat_offset'

class ChessPiece
  attr_reader :position, :notation_letter, :owner

  def initialize(icon: 'X', owner: nil, position: nil, offsets: nil, notation_letter: nil)
    @icon = icon.freeze
    @position = position
    @offsets = offsets
    @notation_letter = notation_letter.nil? ? icon : notation_letter
    @owner = owner
  end

  def move_offsets
    @offsets
  end

  def capture_offsets
    @offsets
  end

  def to_s
    @icon
  end
end
