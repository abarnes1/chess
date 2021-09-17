require_relative '../modules/positioning'
require_relative 'capture'

class ActionCalculator
  extend Positioning

  def initialize; end

  def self.actions_for(piece, piece_collection = nil, move_log = nil)
    actions = []

    if piece_collection.nil?
      actions << default_moves(piece, piece_collection)
    else
      actions << unblocked_moves(piece, piece_collection)
    end

    # add castling, en passant, promote here maybe?
  end

  def self.default_moves(piece, _piece_collection)
    moves = []

    piece.offsets.each do |offset|
      current_position = piece.position
      until current_position.nil?
        current_position = next_position(current_position, offset)

        moves << ActionFactory.create_action(Move, piece, piece.position, current_position) unless current_position.nil?

        break unless offset.is_a? RepeatOffset
      end
    end
  end

  def self.unblocked_moves(piece, piece_collection)
    moves = []

    piece.offsets.each do |offset|
      current_position = piece.position
      until current_position.nil?
        current_position = next_position(current_position, offset)

        break if piece_collection.friendly_at?(piece.owner, current_position)

        moves << if piece_collection.enemy_at?(piece.owner, current_position)
                   capture_piece = piece_collection.select_by_position(current_position)
                   ActionFactory.create_action(Capture, piece, piece.position, current_position, capture_piece)
                 else
                   ActionFactory.create_action(Move, piece, piece.position, current_position)
                 end

        break if !offset.is_a?(RepeatOffset) || piece_collection.occupied_at?(current_position)
      end
    end
  end
end
