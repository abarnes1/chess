# frozen_string_literal: true

require_relative 'action'

# Chess action where a piece can be exchanged for another when
# reaching a position on a standard chessboard.
class Promote < Action
  attr_accessor :promote_to

  def initialize(piece, move_to, promote_to = nil)
    super
    @piece = piece
    @promote_to = promote_to.nil? ? Queen.new(owner: piece.owner) : promote_to
    @move_to = move_to
  end

  def self.create_for(piece, game_state)
    moves = []

    return moves if game_state.nil?

    sequences = path_group_from_offsets(piece.position, piece.move_offsets)

    valid_positions = trim_to_legal(sequences, game_state)
    valid_positions.each do |position|
      break if game_state.occupied_at?(position)

      move = new(piece, position) if piece.can_promote_at?(position)

      moves << move
    end

    moves
  end

  def apply(game_state)
    game_state.remove_piece(piece)

    promote_to.position = move_to

    game_state.add_piece(promote_to)
  end

  def undo(game_state)
    game_state.remove_piece(promote_to)
    game_state.add_piece(piece)
  end

  def to_s
    "promote: #{@piece} to #{@promote_to} at #{@move_to}"
  end

  def notation
    "#{move_to}#{promote_to}"
  end

  class << self
    private

    def trim_to_legal(sequences, game_state)
      return sequences if game_state.nil?

      legal_positions = []

      sequences.each do |sequence|
        sequence.each do |position|
          break if game_state.occupied_at?(position)

          legal_positions << position
        end
      end

      legal_positions
    end
  end
end
