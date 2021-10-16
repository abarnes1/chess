# frozen_string_literal: true

require_relative 'factories/action_factory'
require_relative 'modules/positioning'
require_relative 'threat_map'

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

  attr_reader :pieces, :action_log

  def initialize(pieces = [], action_log = [])
    @pieces = pieces
    @action_log = action_log
    @threat_map = nil
  end

  def add_piece(piece)
    pieces << piece
  end

  def remove_piece(piece)
    pieces.delete(piece)
  end

  def occupied_at?(position)
    piece = select_position(position)

    piece.nil? ? false : true
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

  def friendly_pieces(owner)
    pieces.select { |piece| piece.owner == owner }
  end

  def enemy_pieces(owner)
    pieces.reject { |piece| piece.owner == owner }
  end

  def select_position(position)
    pieces.find { |piece| piece.position == position }
  end

  def select_piece(piece)
    pieces.find { |searched_piece| searched_piece == piece }
  end

  # good above here
  def checkable_pieces(owner)
    pieces = friendly_pieces(owner)

    pieces.select(&:can_be_checked?)
  end

  def log_action(action)
    @action_log << action
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

  def moved?(piece)
    action_log.any? { |action| action.piece == piece }
  end

  def attackable_by_enemy?(friendly_owner, position)
    enemy_pieces = enemy_pieces(friendly_owner)

    @threat_map = calc_threat_map(enemy_pieces)

    @threat_map.include?(position)
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

  def calc_threat_map(pieces_to_map)
    @threat_map = ThreatMap.new(pieces)
    @threat_map.calculate(pieces_to_map)
  end
end
