# frozen_string_literal: true

# Chess action where a piece can be exchanged for another when
# reaching a position on a standard chessboard.
class Promote < Action
  attr_accessor :promote_to
  attr_reader :move_to, :piece

  def initialize(piece, move_to, promote_to = '?')
    super
    @piece = piece
    @promote_to = promote_to
    @move_to = move_to

    puts "initializing #{self}"
  end

  def self.create_for(piece, game_state)
    moves = []

    sequences = calculate_sequences(piece.position, piece.move_offsets)

    sequences.each do |sequence|
      sequence.each do |position|
        break if game_state.occupied_at?(position)

        move = new(piece, position) if game_state.promote?(piece, position)

        moves << move
      end
    end

    moves
  end

  def apply(game_state)
    game_state.log_action(self)

    game_state.remove_piece(piece)
    game_state.add_piece(promote_to)

    promote_to.position = move_to
  end

  def to_s
    "promote: #{@piece} to #{@promote_to} at #{@move_to}"
  end

  def notation
    "#{@move_to}#{@promote_to}"
  end
end
