# frozen_string_literal: true

require_relative 'chesspiece'
require_relative '../movement_helpers'

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

    result = piece.owner != friendly_owner
    puts "occupied_by_enemy? (#{position}): #{result}"
    result
  end

  def friendly_at?(friendly_owner, position)
    piece = select_by_position(position)
    return false if piece.nil?
    
    result = piece.owner == friendly_owner
    puts "occupied_by_friendly? (#{position}): #{result}"
    result
  end

  def occupied_at?(position)
    piece = select_by_position(position)

    piece.nil? ? false : true
  end

  # can single square be attacked by any of my pieces
  def attackable?(position)
    raise NotImplementedError
  end

  # get all pieces that can attack a square
  def pieces_that_attack(position)
    raise NotImplementedError
  end

  def select_by_position(position)
    @pieces.find { |piece| piece.position == position }
  end

  def select_by_piece(piece)
    @pieces.find { |item| item == piece }
  end
end
