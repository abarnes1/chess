# frozen_string_literal: true

require_relative 'factories/action_factory'
require_relative 'modules/positioning'
require_relative 'threat_map'
require_relative 'board_data'
require_relative 'castling_rights'
require_relative 'en_passant_target'

require_relative 'pieces/bishop'
require_relative 'pieces/rook'
require_relative 'pieces/king'
require_relative 'pieces/white_pawn'
require_relative 'pieces/black_pawn'
require_relative 'pieces/knight'
require_relative 'pieces/queen'

# Class for the state of a game of Chess that can answer
# questions necessary to generate piece actions.  Exists to
# simplify questions about aspects of the game state for action
# creation without adding a bunch of methods to the Action class(es).
class GameState
  include Positioning

  attr_reader :half_move_clock

  def initialize(pieces: [], white: 'white', black: 'black')
    @white_player = white
    @black_player = black
    @active_player = @white_player

    @board_data = BoardData.new(pieces: pieces, white: white, black: black)
    @castling_rights = CastlingRights.new(white: white, black: black)
    @en_passant_target = EnPassantTarget.new

    @half_move_clock = 0
    @full_move_counter = 0
    @action_log = []
  end

  def pieces
    @board_data.pieces
  end

  def add_piece(piece)
    @board_data.add_piece(piece)
  end

  def remove_piece(piece)
    @board_data.remove_piece(piece)
  end

  def player_pieces(player)
    @board_data.player_pieces(player)
  end

  def select_position(position)
    @board_data.select_position(position)
  end

  def select_piece(piece)
    @board_data.select_piece(piece)
  end

  def occupied_at?(position)
    !select_position(position).nil?
  end

  def friendly_at?(player, position)
    piece = select_position(position)

    return false if piece.nil?

    piece.owner == player
  end

  def enemy_at?(player, position)
    piece = select_position(position)

    return false if piece.nil?

    piece.owner != player
  end

  def legal_moves
    moves = []

    player_pieces(@active_player).each do |piece|
      moves += ActionFactory.actions_for(piece, self)
    end

    moves.reduce([]) do |legal_moves, move|
      legal_moves << move if legal_move?(move)

      legal_moves
    end
  end

  # good above here
  def castling_rights(player)
    @castling_rights.player_pairs(player)
  end

  def en_passant_target
    @en_passant_target.target
  end

  def in_check?(player)
    king = player_king(player)
    attackable_by_enemy?(king)
  end

  def apply_action(action)
    action.apply(@board_data)
    @castling_rights.update(action.move_from)
    @en_passant_target.update(action)
    update_halfmove(action)
    update_fullmove(@active_player)

    @active_player = @active_player == @white ? @black : @white
    @action_log << action
  end

  def undo_last_action
    action = @action_log.pop
    action.undo(self)
  end

  def legal_state?(owner)
    return false if in_check?(owner)

    true
  end

  def last_moves(count)
    return [] if action_log.empty?

    action_log.reverse[0..count]
  end

  def last_moves_notation(count)
    return [] if action_log.empty?

    to_display = action_log.reverse[0..count]
    to_display.reverse.join("\n")
  end

  def to_fen
    notation = Array.new(6)
    notation[0] = @board_data.to_fen
    notation[1] = @active_player == @white_player ? 'w' : 'b'
    notation[2] = @castling_rights.to_fen
    notation[3] = @en_passant_target.to_fen
    notation[4] = @half_move_clock
    notation[5] = @full_move_counter

    notation.join(' ')
  end

  private

  def find_king(player)
    pieces = player_pieces(player)

    pieces.find { |piece| piece.instance_of?(King) }
  end

  def under_threat?(piece)
    enemy = piece.owner == @white_player ? @black_player : @white_player
    enemy_pieces = player_pieces(enemy)

    threat_map = calc_threat_map(enemy_pieces)

    threat_map.include?(piece.position)
  end

  def legal_move?(move)
    king = find_king(@active_player)
    move.apply(@board_data)

    legal = !under_threat?(king)

    move.undo(@board_data)

    legal
  end

  def calc_threat_map(pieces_to_map)
    threat_map = ThreatMap.new(pieces)
    threat_map.calculate(pieces_to_map)
  end

  def update_halfmove(action)
    @half_move_clock
  end

  def update_fullmove(player)
    @full_move_counter += 1 if player == @black_player
  end
end
