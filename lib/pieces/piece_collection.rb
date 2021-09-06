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

  # considers the collection as a whole
  def moves(piece)
    selected_piece = select_by_piece(piece)

    moves = selected_piece.possible_moves

    moves.each do |move|
      remove_blocked_moves(move)
    end

    moves
  end

  def occupies?(position)
    @pieces.any? { |piece| piece.position == position }
  end

  # can single square be attacked by any of my pieces
  def attackable?(position)
    raise NotImplementedError
  end

  # get all pieces that can attack a square
  def pieces_that_attack(position)
    raise NotImplementedError
  end

  private

  def select_by_position(position)
    # p "finding own piece at position: #{position}"
    @pieces.find { |piece| piece.position == position }
  end

  def select_by_piece(piece)
    @pieces.find { |item| item == piece }
  end

  # asks sequence to mutate, maybe need alternative?
  def remove_blocked_moves(move)
    return if move.sequence.length.zero?

    start = move.start_position
    last = start

    move.sequence[0..-1].each do |position|
      if occupies?(position)
        move.stop_at(last)
        break
      end

      last = position
    end
  end
end
