# frozen_string_literal: true

require_relative 'chesspiece'
require_relative '../modules/positioning'

# Standard king for a game of chess.
class King < ChessPiece
  include Positioning

  def initialize(icon: "\u265A", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @offsets = [
      Offset.new([-1, -1]),
      Offset.new([-1, 1]),
      Offset.new([-1, 0]),
      Offset.new([1, 0]),
      Offset.new([1, -1]),
      Offset.new([1, 1]),
      Offset.new([0, -1]),
      Offset.new([0, 1])
    ]

    @notation_letter = 'K'
  end

  def can_be_checked?
    true
  end

  def initiates_castling?
    true
  end
end
