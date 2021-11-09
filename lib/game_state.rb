# frozen_string_literal: true

require_relative 'factories/action_factory'
require_relative 'modules/positioning'
require_relative 'threat_map'
require_relative 'board_data'
require_relative 'castling_rights'
require_relative 'en_passant_target'
require_relative 'half_move_clock'

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

  attr_reader :active_player, :white_player, :black_player

  def initialize(pieces: [], white: 'white', black: 'black', board_data: nil)
    @white_player = white
    @black_player = black
    @active_player = @white_player
    @white_legal_moves = nil
    @black_legal_moves = nil

    @board_data = board_data.nil? ? BoardData.new(pieces: pieces, white: white, black: black) : board_data
    @castling_rights = CastlingRights.new(white: white, black: black)
    @en_passant_target = EnPassantTarget.new
    @half_move_clock = HalfMoveClock.new
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

  def legal_moves(player)
    if player == white_player
      white_legal_moves
    elsif player == black_player
      black_legal_moves
    else
      []
    end
  end

  def castling_rights(player)
    @castling_rights.player_pairs(player)
  end

  def en_passant_target
    @en_passant_target.target
  end

  def half_move_clock
    @half_move_clock.counter
  end

  def in_check?(player)
    king = @board_data.find_king(player)
    under_threat?(king)
  end

  def apply_action(action)
    action.apply(@board_data)
    @castling_rights.update(action.move_from)
    @en_passant_target.update(action)
    @half_move_clock.update(action)

    @active_player = @active_player == @white_player ? @black_player : @white_player

    @white_legal_moves = nil
    @black_legal_moves = nil
  end

  def legal_move?(player, move)
    king = @board_data.find_king(player)
    move.apply(@board_data)

    legal = !under_threat?(king)

    move.undo(@board_data)

    legal
  end

  def under_threat?(piece)
    enemy = piece.owner == @white_player ? @black_player : @white_player
    enemy_pieces = player_pieces(enemy)

    threat_map = calc_threat_map(enemy_pieces)

    threat_map.include?(piece.position)
  end

  def opposing_player(player = current_player)
    player == @white_player ? @black_player : @white_player
  end

  private

  def calc_threat_map(pieces_to_map)
    threat_map = ThreatMap.new(pieces)
    threat_map.calculate(pieces_to_map)
  end

  def black_legal_moves
    @black_legal_moves = generate_legal_moves(black_player) if @black_legal_moves.nil?

    @black_legal_moves
  end

  def white_legal_moves
    @white_legal_moves = generate_legal_moves(white_player) if @white_legal_moves.nil?

    @white_legal_moves
  end

  def generate_legal_moves(player)
    moves = []

    player_pieces(player).each do |piece|
      moves += ActionFactory.actions_for(piece, self)
    end

    moves.each_with_object([]) do |move, legal_moves|
      legal_moves << move if legal_move?(player, move)

      legal_moves
    end
  end
end
