# frozen_string_literal: true

require_relative 'action'

# A basic chess move where one piece moves from
# its current square to another unoccupied square.
class Move < Action
  def initialize(piece = nil, move_from = nil, move_to = nil)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
  end

  # Create psuedo legal movements.  These are movements that can be made given
  # the game's state, but do not take into account whether or not the completed
  # move leaves the board in an illegal state. An illegal state primarily means
  # that the king would be left vulnerable to attack after the move is made,
  # although this behavior is up to the GameState class.
  def self.create_for(piece, game_state)
    moves = []

    sequences = path_group_from_offsets(piece.position, piece.move_offsets)
    valid_positions = trim_to_legal(sequences, game_state)

    valid_positions.each do |position|
      move = new(piece, piece.position, position) unless piece.can_promote_at?(position)

      moves << move
    end

    moves
  end

  def apply(board_data)
    board_data.move(piece, move_to)
  end

  def undo(board_data)
    board_data.move(piece, move_from)
  end

  def to_s
    "move: #{@piece} from #{@move_from} to #{@move_to}"
  end

  def notation
    "#{@piece.notation_letter}#{@move_to}"
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
