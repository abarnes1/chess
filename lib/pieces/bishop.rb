require_relative 'chesspiece'
require_relative '../position_helpers'

class Bishop < ChessPiece
  include PositionHelpers

  def initialize(position = nil, owner = nil, icon = "\u265D")
    super(position, owner)
    @icon = icon.freeze
    @movements = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  end

  def possible_moves
    moves = []

    @movements.each do |offset|
      new_move = calculate_position(position, offset)

      while inbounds?(new_move)
        moves << new_move
        position = new_move
        new_move = calculate_position(position, offset)
      end
    end

    moves
  end

  def to_s
    @icon
  end
end
