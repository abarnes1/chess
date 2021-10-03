# frozen_string_literal: true

require_relative 'chesspiece'

# Standard rook for a game of chess.
class Rook < ChessPiece
  def initialize(icon: "\u265C", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @offsets = [
      RepeatOffset.new([1, 0]),
      RepeatOffset.new([-1, 0]),
      RepeatOffset.new([0, 1]),
      RepeatOffset.new([0, -1])
    ]

    @notation_letter = 'R'
  end

  def castling_partner?
    true
  end
end
