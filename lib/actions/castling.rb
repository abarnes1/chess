# frozen_string_literal: true

require_relative 'action'

# Castling chess action between a piece that
# initiates castling and a partner piece.
class Castling < Action
  attr_accessor :partner_piece, :partner_move_from, :partner_move_to

  def initialize(piece, move_from, move_to, partner_piece, partner_move_to)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    @partner_piece = partner_piece
    @partner_move_from = partner_piece.position
    @partner_move_to = partner_move_to
  end

  def self.create_for(king, game_state)
    return nil if game_state.nil? || !king.instance_of?(King)

    actions = []

    active_pairs = game_state.castling_rights(king.owner)

    active_pairs.each do |pair|
      next unless valid_pair?(pair, game_state)

      rook = game_state.select_position(pair.rook_position)

      king_destination = king_destination(king, rook)
      rook_destination = rook_destination(king, rook)

      castling = new(king, king.position, king_destination, rook, rook_destination)

      actions << castling unless illegal_movement?(king, rook, game_state)
    end

    actions
  end

  def apply(board_data)
    board_data.move(@piece, move_to)
    board_data.move(@partner_piece, partner_move_to)
  end

  def undo(board_data)
    board_data.move(@piece, move_from)
    board_data.move(@partner_piece, partner_move_from)
  end

  def to_s
    "castling: #{@piece} from #{@move_from} to #{@move_to}, " \
      "#{@partner_piece} from #{@partner_move_from} to #{partner_move_to}"
  end

  def notation
    spaces_moved = (partner_move_from.file.ord - partner_move_to.file.ord).abs
    (['0'] * spaces_moved).join('-')
  end

  class << self
    private

    def valid_pair?(pair, game_state)
      king = game_state.select_position(pair.king_position)
      rook = game_state.select_position(pair.rook_position)

      return false if king.nil? || !king.instance_of?(King)
      return false if rook.nil? || !rook.instance_of?(Rook)
      return false if king.owner != rook.owner

      true
    end

    def king_destination(king, rook)
      x_direction = left_castle?(king, rook) ? -2 : 2
      offset = Offset.new([x_direction, 0])

      path_from_offset(king.position, offset)[0]
    end

    def rook_destination(king, rook)
      x_direction = left_castle?(king, rook) ? 3 : -2

      offset = Offset.new([x_direction, 0])
      path_from_offset(rook.position, offset)[0]
    end

    def left_castle?(king, rook)
      king.position.file > rook.position.file
    end

    def illegal_movement?(king, rook, game_state)
      return true if path_blocked?(king, rook, game_state)
      return true if path_attackable?(king, rook, game_state)

      false
    end

    def path_blocked?(king, rook, game_state)
      path = linear_path_from_positions(king.position, rook.position)
      positions_to_check = path[1...-1]
      positions_to_check.any? { |position| game_state.occupied_at?(position) }
    end

    def path_attackable?(king, rook, game_state)
      destination = king_destination(king, rook)
      path = linear_path_from_positions(king.position, destination)

      path.any? { |position| game_state.under_threat?(king) }
    end
  end
end
