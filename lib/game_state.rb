# frozen_string_literal: true

require_relative 'factories/action_factory'
require_relative 'modules/positioning'
require_relative 'threat_map'
require_relative 'board_data'
require_relative 'castling_rights'
require_relative 'en_passant_target'
require_relative 'half_move_clock'
require_relative 'repetition_log'

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

  attr_reader :active_player, :white_player, :black_player, :full_move_counter, :castling_rights,
              :en_passant_target, :last_move


  def initialize(pieces: [], white: 'white', black: 'black')
    @white_player = white
    @black_player = black
    @active_player = @white_player
    @white_legal_moves = nil
    @black_legal_moves = nil
    @last_move = nil

    @board_data = BoardData.new(pieces: pieces, white: white, black: black)
    @castling_rights = CastlingRights.new(white: white, black: black)
    @en_passant_target = EnPassantTarget.new
    @half_move_clock = HalfMoveClock.new
    @full_move_counter = 1
    @repetition_log = RepetitionLog.new
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

  def player_castling_rights(player)
    @castling_rights.player_pairs(player)
  end

  def active_en_passant_target
    @en_passant_target.target
  end

  def half_move_clock
    @half_move_clock.counter
  end

  def in_check?(player)
    king = @board_data.find_king(player)
    under_threat?(king.position, king.owner)
  end

  def apply_action(action)
    action.apply(@board_data)
    @castling_rights.update(action.move_from)
    @en_passant_target.update(action)
    @half_move_clock.update(action)
    @full_move_counter += 1 if @active_player == @black_player

    @active_player = @active_player == @white_player ? @black_player : @white_player

    @repetition_log.update(repetition_string)

    @white_legal_moves = nil
    @black_legal_moves = nil
    @last_move = action.notation
  end

  def legal_move?(player, move)
    king = @board_data.find_king(player)
    return true if king.nil?

    move.apply(@board_data)

    legal = !under_threat?(king.position, king.owner)

    move.undo(@board_data)

    puts "#{move} legal? #{legal}"
    legal
  end

  def under_threat?(position, player)
    enemy = opposing_player(player)
    enemy_pieces = player_pieces(enemy)

    threat_map = calc_threat_map(enemy_pieces)

    threat_map.include?(position)
  end

  def opposing_player(player = current_player)
    player == @white_player ? @black_player : @white_player
  end

  def repetitions
    @repetition_log.repetitions
  end

  def full_fen
    values = []
    values << board_data.to_fen_component
    values << active_player_fen
    values << castling_rights.to_fen_component
    values << en_passant_target.to_fen_component
    values << half_move_clock
    values << full_move_counter

    values.join(' ')
  end

  def repetition_string
    values = []
    values << board_data.to_fen_component
    values << active_player_fen
    values << castling_rights.to_fen_component
    values << en_passant_target.to_fen_component

    values.join(' ')
  end

  private

  attr_reader :board_data

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

  def active_player_fen
    active_player == white_player ? 'w' : 'b'
  end
end
