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
    piece = select_by_position(position)

    piece.nil? ? false : true
  end

  def friendly_at?(friendly_owner, position)
    piece = select_by_position(position)

    return false if piece.nil?

    piece.owner == friendly_owner
  end

  def enemy_at?(friendly_owner, position)
    piece = select_by_position(position)

    return false if piece.nil?

    piece.owner != friendly_owner
  end

  def friendly_pieces(owner)
    pieces.select { |piece| piece.owner == owner }
  end

  def enemy_pieces(owner)
    pieces.reject { |piece| piece.owner == owner }
  end

  def select_by_position(position)
    pieces.find { |piece| piece.position == position }
  end

  # good above here

  def clone
    Marshal.load(Marshal.dump(self))
  end

  def promote?(piece, position)
    piece.can_promote_at?(position)
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
      actions.any? do |action|
        if action.move_to == position
          # puts "#{piece} at #{piece.position} can attack #{position}"
          return true
        end
      end
    end

    false
  end
end
