# frozen_string_literal: true

require_relative 'chesspiece'

# Standard knight for a game of chess.
class Knight < ChessPiece
  def initialize(icon: "\u265E", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @offsets = [
      Offset.new([2, -1]),
      Offset.new([2,  1]),
      Offset.new([1, -2]),
      Offset.new([-1, -2]),
      Offset.new([-2, 1]),
      Offset.new([-2, -1]),
      Offset.new([-1, 2]),
      Offset.new([1, 2])
    ]

    @notation_letter = 'N'
  end
end
