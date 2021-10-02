# frozen_string_literal: true

require_relative 'factories/action_factory'

require_relative 'pieces/bishop'
require_relative 'pieces/rook'
require_relative 'pieces/king'
require_relative 'pieces/white_pawn'
require_relative 'pieces/black_pawn'

# Class for the state of a game of Chess that can answer
# questions necessary to generate piece actions.  Exists to
# simplify questions about aspects of the game state for action
# creation without adding a bunch of methods to the Action class(es).
class GameState
  attr_reader :pieces, :action_log

  def initialize(pieces = [], action_log = [])
    @pieces = pieces
    @action_log = action_log
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

    # pieces.select { |piece| piece.can_be_checked? }
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

  # can single square be attacked by any of the enemy pieces
  def attackable_by_enemy?(friendly_owner, position)
    enemy_pieces = enemy_pieces(friendly_owner)

    enemy_pieces.each do |piece|
      actions = ActionFactory.actions_for(piece, self)
      actions.any? { |action| return true if action.move_to == position }
    end

    false
  end

  def in_check?(owner)
    checkable_pieces = checkable_pieces(owner)
    checkable_pieces.each { |piece| puts "   #{piece} at #{piece.position}" }
    result = checkable_pieces.any? { |piece| attackable_by_enemy?(piece.owner, piece.position) }
    puts "  in_check? #{result}"
    result
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
end
