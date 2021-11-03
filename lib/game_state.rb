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

    moves.each_with_object([]) do |move, legal_moves|
      legal_moves << move if legal_move?(move)

      legal_moves
    end
  end

  def castling_rights(player)
    @castling_rights.player_pairs(player)
  end

  def en_passant_target
    @en_passant_target.target
  end

  def in_check?(player)
    king = @board_data.find_king(player)
    attackable_by_enemy?(king)
  end

  def apply_action(action)
    action.apply(@board_data)
    @castling_rights.update(action.move_from)
    @en_passant_target.update(action)
    update_half_move_clock(action)

    @active_player = @active_player == @white ? @black : @white
  end

  def legal_state?(owner)
    return false if in_check?(owner)

    true
  end

  private

  def under_threat?(piece)
    enemy = piece.owner == @white_player ? @black_player : @white_player
    enemy_pieces = player_pieces(enemy)

    threat_map = calc_threat_map(enemy_pieces)

    threat_map.include?(piece.position)
  end

  def legal_move?(move)
    king = @board_data.find_king(@active_player)
    move.apply(@board_data)

    legal = !under_threat?(king)

    move.undo(@board_data)

    legal
  end

  def calc_threat_map(pieces_to_map)
    threat_map = ThreatMap.new(pieces)
    threat_map.calculate(pieces_to_map)
  end

  def update_half_move_clock(action)
    return if [WhitePawn, BlackPawn].include?(action.piece) || [Capture, PromoteCapture].include?(action.class)

    @half_move_clock += 1
  end
end
