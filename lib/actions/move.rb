# frozen_string_literal: true

require_relative 'action'

# A basic chess move where one piece moves from
# its current square to another unoccupied square.
class Move < Action
  attr_accessor :piece, :move_from, :move_to

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

    sequences = calculate_sequence_set(piece.position, piece.move_offsets)
    valid_sequences = trim_set_after_collision(sequences, game_state)
    valid_sequences.each do |sequence|
      sequence.each do |position|
        move = new(piece, piece.position, position) unless piece.can_promote_at?(position)

        break if !game_state.nil? && game_state.occupied_at?(position)

        moves << move
      end
    end

    moves
  end

  def apply(_game_state)
    piece.position = move_to
  end

  def undo(_game_state)
    piece.position = move_from
  end

  def to_s
    "move: #{@piece} from #{@move_from} to #{@move_to}"
  end

  def notation
    "#{@piece.notation_letter}#{@move_to}"
  end
end
