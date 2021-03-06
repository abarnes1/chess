# frozen_string_literal: true

require_relative 'chesspiece'

# Pawns that traditonally start on rank 2 for the white player.
class WhitePawn < ChessPiece
  include Positioning

  def initialize(icon: "\u265F", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @notation_letter = 'P'
  end

  def move_offsets
    if position.rank == '2'
      [RepeatOffset.new([0, 1], 2)]
    else
      [Offset.new([0, 1])]
    end
  end

  def capture_offsets
    [
      Offset.new([-1, 1]),
      Offset.new([1, 1])
    ]
  end

  def can_promote_at?(position)
    position.rank == '8'
  end
end
