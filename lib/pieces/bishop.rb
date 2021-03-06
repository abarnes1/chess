# frozen_string_literal: true

require_relative 'chesspiece'

# Standard bishop for a game of chess.
class Bishop < ChessPiece
  include Positioning

  def initialize(icon: "\u265D", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @offsets = [
      RepeatOffset.new([-1, -1]),
      RepeatOffset.new([-1,  1]),
      RepeatOffset.new([1, -1]),
      RepeatOffset.new([1,  1])
    ]

    @notation_letter = 'B'
  end
end
