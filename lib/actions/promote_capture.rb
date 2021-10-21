# frozen_string_literal: true

require_relative 'action'

# A basic chess move where one piece moves from its current
# square to another square occupied by an enemy piece.
class PromoteCapture < Action
  attr_accessor :promote_to
  attr_reader :move_from, :move_to, :piece

  def initialize(piece, move_from, move_to, captured, promote_to = nil)
    super
    @piece = piece
    @promote_to = promote_to.nil? ? ChessPiece.new(owner: piece.owner, icon: '?') : promote_to
    @move_to = move_to
    @move_from = move_from
    @captured = captured
  end

  def self.create_for(piece, game_state)
    moves = []

    return moves if game_state.nil?

    sequences = path_group_from_offsets(piece.position, piece.capture_offsets)

    sequences.each do |sequence|
      capturable_piece = first_capturable_piece(piece, game_state, sequence)

      next if capturable_piece.nil?

      moves << new(piece, piece.position, capturable_piece.position, capturable_piece)
    end

    moves
  end

  def apply(game_state)
    game_state.remove_piece(piece)
    game_state.remove_piece(@captured)
    game_state.add_piece(promote_to)

    promote_to.position = move_to
  end

  def undo(game_state)
    game_state.remove_piece(promote_to)
    game_state.add_piece(piece)
    game_state.add_piece(@captured)
  end

  def to_s
    "promote capture: #{@piece} to #{@promote_to} at #{@move_to}"
  end

  def notation
    "#{move_from}x#{move_to}=#{@promote_to}"
  end

  class << self
    private

    def first_capturable_piece(piece, game_state, sequence)
      sequence.each do |position|
        break if game_state.friendly_at?(piece.owner, position)

        next unless game_state.enemy_at?(piece.owner, position)

        capture_piece = game_state.select_position(position)
        return capture_piece if piece.can_promote_at?(position)
      end

      nil
    end
  end
end
