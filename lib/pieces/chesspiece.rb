# frozen_string_literal: true

require_relative '../movement/offset'
require_relative '../movement/repeat_offset'
require_relative '../factories/action_factory'

# Implementation of ChessPiece interface that child classes
# of specific pieces can implement or override.
class ChessPiece
  attr_accessor :position
  attr_reader :notation_letter, :owner

  def initialize(icon: '?', owner: nil, position: nil, offsets: nil, notation_letter: nil)
    @icon = icon.freeze
    @position = position
    @offsets = offsets
    @notation_letter = notation_letter.nil? ? icon : notation_letter
    @owner = owner
  end

  def actions(game_state = nil)
    ActionFactory.actions_for(self, game_state)
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

  def can_promote_at?(_position = nil)
    false
  end
end
