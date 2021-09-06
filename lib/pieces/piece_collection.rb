# frozen_string_literal: true

require_relative 'chesspiece'

class PieceCollection
  attr_reader :pieces

  def initialize(pieces: [])
    @pieces = pieces
  end

  def add(piece)
    return nil unless piece.is_a? ChessPiece

    @pieces << piece
  end

  def remove(piece)
    return nil unless piece.is_a? ChessPiece

    @pieces.delete(piece)
  end

  def select_by_piece(piece)
    @pieces.find { |item| item == piece }
  end

  def moves(piece)
    # p "finding own piece #{piece}"
    selected_piece = select_by_piece(piece)

    selected_piece.possible_moves
  end

  def select_by_position(position)
    # p "finding own piece at position: #{position}"
    @pieces.find { |piece| piece.position == position}
  end

  # can single square be attacked by any of my pieces
  def attackable?(position)
    raise NotImplementedError
  end

  # get all pieces that can attack a square
  def pieces_that_attack(position) 
    raise NotImplementedError
  end
end
