# frozen_string_literal: true

# A basic chess move where one piece moves from its current
# square to another square occupied by an enemy piece.
class Capture < Action
  attr_reader :piece, :move_to, :move_from

  def initialize(piece, move_from, move_to, captured)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    @captured = captured
  end

  def self.create_for(piece, game_state)
    moves = []

    return moves if game_state.nil?

    sequences = calculate_sequence_set(piece.position, piece.capture_offsets)

    sequences.each do |sequence|
      capturable_piece = first_capturable_piece(piece, game_state, sequence)

      next if capturable_piece.nil?

      capture = new(piece, piece.position, capturable_piece.position, capturable_piece)
      moves << capture
    end

    moves
  end

  def apply(game_state)
    @captured = game_state.select_position(move_to)
    piece.position = move_to

    game_state.remove_piece(@captured)
  end

  def undo(game_state)
    piece.position = move_from

    game_state.add_piece(@captured)
  end

  def to_s
    "capture: #{@piece} from #{@move_from} to #{@move_to} and capture #{@captured}"
  end

  def notation
    "#{@piece.notation_letter}x#{@move_to}"
  end

  class << self
    private

    def first_capturable_piece(piece, game_state, sequence)
      sequence.each do |position|
        break if game_state.friendly_at?(piece.owner, position)

        next unless game_state.enemy_at?(piece.owner, position)

        capture_piece = game_state.select_position(position)
        return capture_piece unless piece.can_promote_at?(position)
      end

      nil
    end
  end

end
