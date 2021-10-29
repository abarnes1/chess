# frozen_string_literal: true

require_relative 'factories/action_factory'
require_relative 'modules/positioning'
require_relative 'threat_map'
require_relative 'piece_storage'

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

  attr_reader :pieces

  def initialize(pieces: [], white: 'white', black: 'black')
    @white_player = white
    @black_player = black
    @pieces = PieceStorage.new(pieces: pieces, white: white, black: black)
    @castling_rights = CastlingRights.new(white: white, black: black)
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

  def checkable_pieces(owner)
    pieces = friendly_pieces(owner)

    pieces.select(&:can_be_checked?)
  end

  def attackable_by_enemy?(friendly_owner, position)
    enemy = opposing_player(friendly_owner)
    enemy_pieces = enemy_pieces(enemy)

    threat_map = calc_threat_map(enemy_pieces)

    threat_map.include?(position)
  end

  def in_check?(owner)
    checkable_pieces = checkable_pieces(owner)
    checkable_pieces.any? { |piece| attackable_by_enemy?(piece.owner, piece.position) }
  end

  def apply_action(action)
    action.apply(self)
    action_log << action
  end

  def undo_last_action
    action = action_log.pop
    action.undo(self)
  end

  def legal_state?(owner)
    return false if in_check?(owner)

    true
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
    @threat_map = ThreatMap.new(pieces)
    @threat_map.calculate(pieces_to_map)
  end
end
