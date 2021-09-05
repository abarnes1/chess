require_relative 'chesspiece'
require_relative '../position_helpers'

class Rook < ChessPiece
  include PositionHelpers

  def initialize(icon: "\u265C", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)
    @movements = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    @algebraic_letter = 'R'.freeze
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
end