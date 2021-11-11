# frozen_string_literal: true

require_relative 'action'
require 'pry-byebug'

# A chess move that allows pawns to capture other pawns that
# move past their capturable positions on the previous turn.
class EnPassant < Action
  attr_reader :captured

  def initialize(piece, move_from, move_to, captured)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    @captured = captured
  end

  def self.create_for(piece, game_state)
    return nil if game_state.nil? || !valid_initiator?(piece)

    # binding.pry
    target_position = game_state.active_en_passant_target

    return nil if target_position.nil?
    return nil unless attackable?(piece, target_position)

    captured_position = identify_capture_position(piece, target_position)
    captured_piece = game_state.select_position(captured_position)

    new(piece, piece.position, target_position, captured_piece)
  end

  def self.valid_initiator?(initiator)
    return false unless [WhitePawn, BlackPawn].include?(initiator.class)

    true
  end

  def apply(board_data)
    board_data.remove_piece(@captured)

    board_data.move(piece, move_to)
  end

  def undo(board_data)
    board_data.move(piece, move_from)

    board_data.add_piece(@captured)
  end

  def to_s
    "en passant capture: #{@piece} from #{@move_from} to #{@move_to} and capture #{@captured} at #{@captured.position}"
  end

  def notation
    "#{@piece.position.file}x#{@move_to} e.p."
  end

  class << self
    private

    def attackable?(piece, position)
      attackable_positions = path_group_from_offsets(piece.position, piece.capture_offsets).flatten
      attackable_positions.any? { |attackable| attackable == position }
    end

    def identify_capture_position(piece, en_passant_target)
      offset_from_pawn = if left_target?(piece.position, en_passant_target)
                           Offset.new([-1, 0])
                         else
                           Offset.new([1, 0])
                         end

      # puts path_from_offset(piece.position, offset_from_pawn)[0]
      path_from_offset(piece.position, offset_from_pawn)[0]
    end

    def left_target?(position, en_passant_target)
      en_passant_target.file < position.file
    end
  end
end
