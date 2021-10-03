# frozen_string_literal: true

require_relative 'chesspiece'

# Standard queen for a game of chess.
class Queen < ChessPiece
  def initialize(icon: "\u265B", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @offsets = [
      RepeatOffset.new([-1, -1]),
      RepeatOffset.new([-1,  1]),
      RepeatOffset.new([1, -1]),
      RepeatOffset.new([1,  1]),
      RepeatOffset.new([1, 0]),
      RepeatOffset.new([-1, 0]),
      RepeatOffset.new([0, 1]),
      RepeatOffset.new([0, -1])
    ]

    @notation_letter = 'Q'
  end
end
