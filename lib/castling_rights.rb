# frozen_string_literal: true

require_relative 'castling_pair'
require_relative 'position'

# Castling rights for both white and black players in a game of chess.
class CastlingRights
  def initialize(white: 'white', black: 'black')
    @white = white
    @black = black

    @white_king_side = CastlingPair.new(Position.new('e1'), Position.new('h1'))
    @white_queen_side = CastlingPair.new(Position.new('e1'), Position.new('a1'))
    @black_king_side = CastlingPair.new(Position.new('e8'), Position.new('h8'))
    @black_queen_side = CastlingPair.new(Position.new('e8'), Position.new('a8'))
  end

  def player_pairs(player)
    if player == @white
      [@white_king_side, @white_queen_side]
    elsif player == @black
      [@black_king_side, @black_queen_side]
    else
      []
    end
  end

  def update(position_moved_from)
    @white_king_side.update(position_moved_from)
    @white_queen_side.update(position_moved_from)
    @black_king_side.update(position_moved_from)
    @black_queen_side.update(position_moved_from)
  end

  def to_fen_component
    output = ''

    output += 'K' if @white_king_side.enabled?
    output += 'Q' if @white_queen_side.enabled?
    output += 'k' if @black_king_side.enabled?
    output += 'q' if @black_queen_side.enabled?

    output.empty? ? '-' : output
  end
end
