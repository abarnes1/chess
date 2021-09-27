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

    puts "initializing #{self}"
  end

  def self.create_for(piece, game_state)
    moves = []

    sequences = calculate_sequences(piece.position, piece.move_offsets)

    sequences.each do |sequence|
      sequence.each do |position|
        break if game_state.blocked_at?(position)

        move = new(piece, piece.position, position) unless game_state.promote?(piece, position)

        moves << move
      end
    end

    moves
  end

  def apply(game_state)
    game_state.log_action(self)
    piece.position = move_to
  end

  def to_s
    "move: #{@piece} from #{@move_from} to #{@move_to}"
  end

  def notation
    "#{@piece.notation_letter}#{@move_to}"
  end
end
