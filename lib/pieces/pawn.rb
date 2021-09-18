# frozen_string_literal: true

require_relative 'chesspiece'

class Pawn < ChessPiece
  include Positioning

  def initialize(icon: "\u265F", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @notation_letter = ''
  end
end