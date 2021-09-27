# frozen_string_literal: true

# Wrapper for the state of a game of Chess that can answer
# questions necessary to generate piece actions.  Exists to
# simplify questions about aspects of the game state for action
# creation without adding a bunch of methods to the Action class(es).
class GameState
  attr_reader :piece_collection, :action_log

  def initialize(piece_collection = nil, action_log = [])
    @piece_collection = piece_collection
    @action_log = action_log
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end

  def promote?(piece, position)
    piece.can_promote_at?(position)
  end

  def blocked_at?(position)
    return false if piece_collection.nil?

    piece_collection.occupied_at?(position)
  end

  def blocked_by_friendly?(owner, position)
    return false if piece_collection.nil?

    piece_collection.friendly_at?(owner, position)
  end

  def enemy_at?(owner, position)
    return false if piece_collection.nil?

    piece_collection.enemy_at?(owner, position)
  end

  def select_by_position(position)
    piece_collection.select_by_position(position)
  end

  def add_piece(piece)
    piece_collection.add(piece)
  end

  def remove_piece(piece)
    piece_collection.remove(piece)
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
  # can single square be attacked by any of my pieces
  def attackable?(position)
    raise NotImplementedError
  end

  # get all pieces that can attack a square
  def pieces_that_attack(position)
    raise NotImplementedError
  end
end
