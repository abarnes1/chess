# frozen_string_literal: true

class ChessPiece
  attr_reader :position, :algebraic_letter

  def initialize(icon: 'X', position: nil)
    @icon = icon.freeze
    @position = position
    @notation_letter = 'X'.freeze
  end

  def possible_moves
    raise NotImplementedError
  end

  def to_s
    @icon
  end
end