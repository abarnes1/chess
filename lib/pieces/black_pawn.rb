# frozen_string_literal: true

require_relative 'pawn'

# Pawns that traditonally start on rank 7 for the black player.
class BlackPawn < ChessPiece
  include Positioning

  def initialize(icon: "\u265F", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @notation_letter = ''
  end

  def move_offsets
    if position.rank == '7'
      [RepeatOffset.new([0, -1], 2)]
    else
      [Offset.new([0, -1])]
    end
  end

  def capture_offsets
    [Offset.new([-1, -1]), Offset.new([1, -1])]
  end

  def promote_at?(position)
    position.rank == '1'
  end
end
