# frozen_string_literal: true

require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/white_pawn'
require_relative 'pieces/black_pawn'

# Internal storage of pieces on a chessboard that allows for placement,
# removal, and retrieval of pieces.
class BoardData
  def initialize(pieces: nil, white: 'white', black: 'black')
    @positions = Array.new(64)
    @white_player = white
    @black_player = black

    pieces&.each { |piece| add_piece(piece) } unless pieces.nil?
  end

  def add_piece(piece)
    index = position_to_index(piece.position)

    @positions[index] = piece
  end

  def remove_piece(piece)
    index = position_to_index(piece.position)

    @positions[index] = nil
  end

  def move(piece, position)
    remove_piece(piece)
    piece.position = position
    add_piece(piece)
  end

  def pieces
    @positions.reject(&:nil?)
  end

  def player_pieces(player)
    @positions.each_with_object([]) do |piece, pieces|
      pieces << piece unless piece.nil? || player != piece.owner

      pieces
    end
  end

  def select_position(position)
    index = position_to_index(position)

    @positions[index]
  end

  def select_piece(piece)
    index = position_to_index(piece.position)

    @positions[index]
  end

  def apply(action)
    action.apply(self)
  end

  def undo(action)
    action.undo(self)
  end

  def find_king(player)
    pieces = player_pieces(player)

    pieces.find { |piece| piece.instance_of?(King) }
  end

  def to_fen_component
    output = []
    ('1'..'8').to_a.each do |rank|
      current_rank = select_rank(rank)
      output << encode_rank_to_fen(@white_player, current_rank)
    end

    output.reverse.join('/')
  end

  def encode_rank_to_fen(white_owner, rank)
    output = ''
    gap = 0

    rank.each do |piece|
      if piece.nil?
        gap += 1
      else
        output += gap.to_s if gap.positive?
        gap = 0

        output += piece.owner == white_owner ? piece.notation_letter : piece.notation_letter.downcase
      end
    end

    output += gap.to_s if gap.positive?

    output
  end

  private

  def position_to_index(position)
    # 'a8' => 0, 'h1' => 63 (index is top to bottom, left to right)
    index_from_file = position.file.ord - 97
    index_from_rank = (8 - position.rank.to_i) * 8

    index_from_file + index_from_rank
  end

  def select_rank(rank)
    ('a'..'h').to_a.reduce([]) do |rank_objects, file|
      index = position_to_index(Position.new(file + rank))

      rank_objects << @positions[index]
    end
  end
end
