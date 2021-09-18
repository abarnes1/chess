require_relative '../modules/positioning'
require_relative 'capture'

class ActionCalculator
  extend Positioning

  def initialize; end

  def self.actions_for(piece, piece_collection = nil, move_log = nil)
    actions = []

    actions << moves_for(piece, piece_collection)
    actions << captures_for(piece, piece_collection)

    puts 'all actions: '
    puts actions
  end

  def self.moves_for(piece, piece_collection)
    moves = []

    piece.move_offsets.each do |offset|
      current_position = piece.position
      until current_position.nil?
        current_position = next_position(current_position, offset)

        break if !piece_collection.nil? && piece_collection.occupied_at?(current_position)

        moves << ActionFactory.create_action(Move, piece, piece.position, current_position) unless current_position.nil?

        break unless offset.is_a?(RepeatOffset)
      end
    end

    moves
  end

  def self.captures_for(piece, piece_collection)
    return [] if piece_collection.nil?

    moves = []

    piece.capture_offsets.each do |offset|
      current_position = piece.position
      until current_position.nil?
        current_position = next_position(current_position, offset)

        break if piece_collection.friendly_at?(piece.owner, current_position)

        if piece_collection.enemy_at?(piece.owner, current_position)
          capture_piece = piece_collection.select_by_position(current_position)
          moves << ActionFactory.create_action(Capture, piece, piece.position, current_position, capture_piece)
          break
        end

        break unless offset.is_a?(RepeatOffset)
      end
    end

    moves
  end
end
