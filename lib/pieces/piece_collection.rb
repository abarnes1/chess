# frozen_string_literal: true

require_relative 'chesspiece'

# A set of chess pieces, both friend and foe.
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

  def enemy_at?(friendly_owner, position)
    piece = select_by_position(position)

    return false if piece.nil?

    piece.owner != friendly_owner
  end

  def friendly_at?(friendly_owner, position)
    return false if position.nil?

    piece = select_by_position(position)
    return false if piece.nil?

    piece.owner == friendly_owner
  end

  def occupied_at?(position)
    piece = select_by_position(position)

    piece.nil? ? false : true
  end

  def select_by_position(position)
    @pieces.find { |piece| piece.position == position }
  end

  def select_by_piece(piece)
    @pieces.find { |item| item == piece }
  end

  def enemy_pieces(owner)
    @pieces.reject { |piece| piece.owner == owner }
  end

  def friendly_pieces(owner)
    @pieces.select { |piece| piece.owner == owner }
  end
end
