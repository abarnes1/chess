# frozen_string_literal: true

require_relative '../modules/positioning'
require_relative '../pieces/pawn'
require_relative '../factories/action_factory'

class ActionCalculator
  extend Positioning

  def initialize; end

  def self.actions_for(piece, piece_collection = nil, move_log = nil)
    actions = []

    actions << moves_for(piece, piece_collection)
    actions << captures_for(piece, piece_collection)

    # puts 'all actions: '
    # puts actions.flatten.map(&:notation).join("\n")

    actions.flatten
  end

  def self.moves_for(piece, piece_collection)
    moves = []

    sequences = calculate_sequences(piece.position, piece.move_offsets)

    sequences.each do |sequence|
      sequence.each do |position|
        break if !piece_collection.nil? && piece_collection.occupied_at?(position)

        moves << if piece.is_a?(Pawn) && piece.can_promote?(position)
                   ActionFactory.create_action(Promote, piece, '?', position)
                 else
                   ActionFactory.create_action(Move, piece, piece.position, position)
                 end
      end
    end

    moves
  end

  def self.captures_for(piece, piece_collection)
    moves = []

    sequences = calculate_sequences(piece.position, piece.capture_offsets)

    sequences.each do |sequence|
      sequence.each do |position|
        break if !piece_collection.nil? && piece_collection.friendly_at?(piece.owner, position)

        if piece_collection.enemy_at?(piece.owner, position)
          capture_piece = piece_collection.select_by_position(position)
          moves << ActionFactory.create_action(Capture, piece, piece.position, position, capture_piece)
          break
        end
      end
    end

    moves
  end

  # def self.captures_for(piece, piece_collection)
  #   return [] if piece_collection.nil?

  #   moves = []

  #   piece.capture_offsets.each do |offset|
  #     counter = 0

  #     current_position = piece.position
  #     until current_position.nil?
  #       counter += 1
  #       current_position = next_position(current_position, offset)

  #       break if current_position.nil? || piece_collection.friendly_at?(piece.owner, current_position)

  #       if piece_collection.enemy_at?(piece.owner, current_position)
  #         capture_piece = piece_collection.select_by_position(current_position)
  #         moves << ActionFactory.create_action(Capture, piece, piece.position, current_position, capture_piece)
  #         break
  #       end

  #       break unless offset.is_a?(RepeatOffset) && offset.continue?(counter)
  #     end
  #   end

  #   moves
  # end
end
