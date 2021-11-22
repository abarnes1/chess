# frozen_string_literal: true

require_relative 'position'

# King and rook pair used to track when castling is available.
class CastlingPair
  attr_reader :king_position, :rook_position

  def initialize(king_position, rook_position)
    @king_position = king_position
    @rook_position = rook_position

    @enabled = true
  end

  def enabled?
    @enabled
  end

  def update(position_moved_from)
    @enabled = false if [@king_position, @rook_position].any? { |position| position == position_moved_from }
  end
end
