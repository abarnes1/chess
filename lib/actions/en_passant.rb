# frozen_string_literal: true

# A chess move that allows pawns to capture other pawns that
# move past their capturable positions on the previous turn.
class EnPassant < Action
  attr_reader :piece, :move_to, :move_from, :captured

  def initialize(piece, move_from, move_to, captured)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    @captured = captured
    puts "initializing #{self}"
  end

  def self.create_for(piece, game_state)
    return nil unless piece.can_en_passant?(game_state)

    capture_positions = calculate_sequences(piece.position, piece.capture_offsets).flatten
    previous_move = game_state.last_moves(1)[0]

    capture_positions.each do |position|
      next unless previous_move.move_to.file == position.file

      en_passant = new(piece, piece.position, position, previous_move.piece)
      return en_passant
    end

    nil
  end

  def apply(game_state)
    game_state.log_action(self)

    @captured = game_state.select_by_position(move_to)
    piece.position = move_to

    game_state.remove_piece(@captured)
  end

  def to_s
    "en passant capture: #{@piece} from #{@move_from} to #{@move_to} and capture #{@captured}"
  end

  def notation
    "#{@piece.notation_letter}x#{@move_to}"
  end
end
