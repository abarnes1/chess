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

    last_move = game_state.last_moves(1)[0]

    return nil unless move_enables_en_passant?(piece, last_move)

    capture_position = identify_capture_position(piece, last_move)
    target = game_state.select_position(last_move.move_to)

    new(piece, piece.position, capture_position, target)
  end

  def self.valid_initiator?(initiator)
    return false unless [WhitePawn, BlackPawn].include?(initiator.class)

    true
  end

  def self.move_enables_en_passant?(initiator, last_action)
    # last move must be:
    #  - made by opposing pawns
    #  - pawn must have moved 2 spaces
    #  - passed the initiating pawn's capture

    return false if last_action.nil?
    return false unless targets_valid_piece?(initiator, last_action.piece)
    return false unless two_space_move?(last_action)
    return false unless passed_capturable_square?(initiator, last_action)

    true
  end

  def self.targets_valid_piece?(initiator, target)
    return false if initiator.owner == target.owner

    if initiator.is_a?(BlackPawn) && target.is_a?(WhitePawn)
      true
    elsif initiator.is_a?(WhitePawn) && target.is_a?(BlackPawn)
      true
    else
      false
    end
  end

  def self.two_space_move?(last_action)
    return false unless last_action.is_a?(Move)

    path = linear_path_from_positions(last_action.move_from, last_action.move_to)
    path.size - 1 == 2
  end

  def self.passed_capturable_square?(initiator, last_move)
    return nil if last_move.nil?

    path = linear_path_from_positions(last_move.move_from, last_move.move_to)

    return nil if path.nil?

    attackable_squares = path_group_from_offsets(initiator.position, initiator.capture_offsets).flatten
    passed_square = path[1]

    attackable_squares.include?(passed_square)
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
    "#{@piece.position.file}x#{@move_to} e.p."
  end

  class << self
    private

    def identify_capture_position(initiator, last_move)
      capture_positions = path_group_from_offsets(initiator.position, initiator.capture_offsets).flatten
      path = linear_path_from_positions(last_move.move_from, last_move.move_to)

      capture_positions.find { |attackable| path.include?(attackable) }
    end
  end
end
