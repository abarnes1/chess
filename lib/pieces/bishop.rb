# frozen_string_literal: true

require_relative 'chesspiece'
require_relative '../position_helpers'

class Bishop < ChessPiece
  include PositionHelpers

  def initialize(icon: "\u265D", position: nil)
    super(icon: icon, position: position)
    @movements = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    @notation_letter = 'B'.freeze
  end

  def possible_moves
    moves = []

    @movements.each do |offset|
      new_move = Move.new(position)

      new_move.sequence = generate_sequence(new_move, offset)
      moves << new_move unless new_move.sequence.empty?
    end

    moves
  end

  private

  def generate_sequence(move, offset)
    sequence = []
    next_position = calculate_position(move.start_position, offset)

    while inbounds?(next_position)
      sequence << next_position
      next_position = calculate_position(next_position, offset)
    end

    sequence
  end
end
