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
class ArrayStorage
  def initialize(pieces: nil, white: 'white', black: 'black')
    @positions = Array.new(64)
    @white_player = white
    @black_player = black

    pieces&.each { |piece| add_piece(piece) } unless pieces.empty?
  end

  def add_piece(piece)
    index = position_to_index(piece.position)

    @positions[index] = piece
  end

  def remove_piece(piece)
    index = position_to_index(piece.position)

    @positions[index] = nil
  end

  def white_pieces
    player_pieces(@white)
  end

  def black_pieces
    player_pieces(@black)
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
    raise NotImplementedError
  end

  def undo(action)
    raise NotImplementedError
  end

  def select_rank(rank)
    ('a'..'h').to_a.reduce([]) do |rank_objects, file|
      index = position_to_index(Position.new(file + rank))

      rank_objects << @positions[index]
    end
  end

  def to_fen
    output = []
    ('1'..'8').to_a.each do |rank|
      current_rank = select_rank(rank)
      output << encode_rank_to_fen(@white_player, current_rank)
    end

    output.reverse.join('/')
  end

  def self.from_fen(white: nil, black: nil, fen: nil)
    fen_ranks = fen.split('/').reverse

    pieces = []

    fen_ranks.each_with_index do |rank, index|
      pieces += decode_fen_to_rank(rank, index + 1, white, black)
    end

    new(pieces: pieces, white: white, black: black)
  end

  private

  def player_pieces(owner)
    @positions.each_with_object([]) do |piece, pieces|
      pieces << piece unless piece.nil? || owner != piece.owner

      pieces
    end
  end

  def position_to_index(position)
    # 'a8' => 0, 'h1' => 63 (index is top to bottom, left to right)
    index_from_file = position.file.ord - 97
    index_from_rank = (8 - position.rank.to_i) * 8

    index_from_file + index_from_rank
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

  class << self
    private

    def decode_fen_to_rank(rank_string, rank, white_player, black_player)
      current_file = 'a'.ord

      pieces = []

      rank_string.chars.each do |letter|
        break if current_file > 'h'.ord

        if ('1'..'8').include?(letter)
          current_file += letter.to_i
        else
          position = Position.new(current_file.chr + rank.to_s)
          pieces << piece_from_fen_notation(letter, position, white_player, black_player)
          current_file += 1
        end
      end

      pieces
    end

    def piece_from_fen_notation(letter, position, white_player, black_player)
      case letter
      when 'P'
        WhitePawn.new(position: position, owner: white_player)
      when 'R'
        Rook.new(position: position, owner: white_player)
      when 'N'
        Knight.new(position: position, owner: white_player)
      when 'B'
        Bishop.new(position: position, owner: white_player)
      when 'Q'
        Queen.new(position: position, owner: white_player)
      when 'K'
        King.new(position: position, owner: white_player)
      when 'p'
        BlackPawn.new(position: position, owner: black_player)
      when 'r'
        Rook.new(position: position, owner: black_player)
      when 'n'
        Knight.new(position: position, owner: black_player)
      when 'b'
        Bishop.new(position: position, owner: black_player)
      when 'q'
        Queen.new(position: position, owner: black_player)
      when 'k'
        King.new(position: position, owner: black_player)
      end
    end
  end
end
