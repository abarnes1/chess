# frozen_string_literal: true

require_relative '../movement/offset'
require_relative '../movement/repeat_offset'

# Implementation of ChessPiece interface that child classes
# of specific pieces can implement or override.
class ChessPiece
  attr_accessor :position
  attr_reader :notation_letter, :owner

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

  def can_promote_at?(_position)
    false
  end

  def can_en_passant?(_game_state)
    false
  end

  def can_be_checked?
    false
  end

  def can_castle?(_game_state)
    false
  end

  def castling_partner?
    false
  end

  def valid_castling_partners(_game_state)
    nil
  end
end
