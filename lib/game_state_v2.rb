# frozen_string_literal: true

require_relative 'factories/action_factory'
require_relative 'modules/positioning'
require_relative 'threat_map'
require_relative 'piece_storage'
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
class GameStateV2
  include Positioning

  attr_reader :action_log

  def initialize(pieces: [], white: 'white', black: 'black')
    @white_player = white
    @black_player = black
    @pieces = PieceStorage.new(pieces: pieces, white: white, black: black)
    @castling_rights = CastlingRights.new(white: white, black: black)
    @en_passant_target = EnPassantTarget.new
    @action_log = []
  end

  def pieces
    @pieces.pieces
  end

  def add_piece(piece)
    @pieces.add_piece(piece)
  end

  def remove_piece(piece)
    @pieces.remove_piece(piece)
  end

  def friendly_pieces(owner)
    pieces.select { |piece| piece.owner == owner }
  end

  def select_position(position)
    @pieces.select_position(position)
  end

  def select_piece(piece)
    @pieces.select_piece(piece)
  end

  def occupied_at?(position)
    !select_position(position).nil?
  end

  def friendly_at?(friendly_owner, position)
    piece = select_position(position)

    return false if piece.nil?

    piece.owner == friendly_owner
  end

  def enemy_at?(friendly_owner, position)
    piece = select_position(position)

    return false if piece.nil?

    piece.owner != friendly_owner
  end

  # good above here
  def castling_rights(player)
    @castling_rights.player_pairs(player)
  end

  def en_passant_target
    @en_passant_target.target
  end

  def player_king(owner)
    pieces = friendly_pieces(owner)

    pieces.first { |piece| piece.instance_of?(King)}
  end

  def attackable_by_enemy?(friendly_owner, position)
    enemy = opposing_player(friendly_owner)
    enemy_pieces = enemy_pieces(enemy)

    threat_map = calc_threat_map(enemy_pieces)

    threat_map.include?(position)
  end

  def in_check?(owner)
    king = player_king(owner)
    attackable_by_enemy?(king.owner, king.position)
  end

  def apply_action(action)
    action.apply(self)
    @castling_rights.update(action.move_from)
    @en_passant_target.update(action)
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

  private

  def enemy_pieces(owner)
    if owner == @white
      @pieces.white_pieces
    elsif owner == @black
      @pieces.black_pieces
    else
      []
    end
  end

  def opposing_player(player)
    player == @white ? @black : @white
  end

  def calc_threat_map(pieces_to_map)
    threat_map = ThreatMap.new(pieces)
    threat_map.calculate(pieces_to_map)
  end
end
