require_relative 'chesspiece'
require_relative '../position_helpers'

class Bishop < ChessPiece
  include PositionHelpers

  attr_reader :notation

  def initialize(icon: "\u265D", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)
    @movements = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    @notation = 'B'.freeze
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
