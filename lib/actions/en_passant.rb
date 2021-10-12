# frozen_string_literal: true

require_relative 'action'

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
  end

  def self.create_for(piece, game_state)
    return nil if game_state.nil? || !valid_initiator?(piece)

    target = identify_valid_target(piece, game_state)

    return nil if game_state.nil? || target.nil?

    capture_position = identify_capture_position(piece, target)

    if capture_position.nil?
      nil
    else
      new(piece, piece.position, capture_position, target)
    end
  end

  def self.valid_initiator?(initiator)
    return false unless [WhitePawn, BlackPawn].include?(initiator.class)

    true
  end

  def self.last_move_enables_en_passant?(initiator, last_action)
    # last move must be:
    #  - made by an enemy pawn
    #  - enemy must be targetable
    #  - passed the initiator's capture

    return false if last_action.nil?
    return false unless last_action_by_enemy?(initiator, last_action.piece)
    return false unless valid_target?(initiator, last_action.piece)
    return false unless passed_capturable?(initiator, last_action)

    true
  end

  def self.valid_target?(initiator, target)
    if initiator.is_a?(BlackPawn) && target.is_a?(WhitePawn)
      true
    elsif initiator.is_a?(WhitePawn) && target.is_a?(BlackPawn)
      true
    else
      false
    end
  end

  def self.last_action_by_enemy?(initiator, last_action_piece)
    initiator.owner != last_action_piece.owner
  end

  def self.passed_capturable?(initiator, last_move)
    return nil unless [WhitePawn, BlackPawn].include?(initiator.class)
    return nil unless [WhitePawn, BlackPawn].include?(last_move.piece.class)
    return nil if last_move.nil?

    rank_distance = distance_between_ranks(last_move.move_from, last_move.move_to)
    file_distance = distance_between_files(initiator.position, last_move.move_to)

    rank_distance == 2 && file_distance == 1
  end

  def apply(game_state)
    piece.position = move_to

    game_state.remove_piece(@captured)
  end

  def undo(game_state)
    piece.position = move_from

    game_state.add_piece(@captured)
  end

  def to_s
    "en passant capture: #{@piece} from #{@move_from} to #{@move_to} and capture #{@captured} at #{@captured.position}"
  end

  def notation
    "#{@piece.notation_letter}x#{@move_to}"
  end

  class << self
    private

    def identify_valid_target(initiator, game_state)
      last_action = game_state.last_moves(1)[0]

      return nil unless last_move_enables_en_passant?(initiator, last_action)

      last_action.piece
    end

    def y_direction(start_position, end_position)
      start_position.rank.to_i > end_position.rank.to_i ? -1 : 1
    end

    def identify_capture_position(initiator, target)
      capture_positions = calculate_sequence_set(initiator.position, initiator.capture_offsets).flatten

      capture_positions.each do |position|
        return position if position.file == target.position.file
      end
    end
  end
end
