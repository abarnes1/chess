# frozen_string_literal: true

require_relative 'modules/positioning'
require_relative 'pieces/black_pawn'
require_relative 'pieces/white_pawn'
require_relative 'actions/move'

# Tracks the current (if any) position that is capturable via en passant.
class EnPassantTarget
  include Positioning

  attr_reader :target

  def initialize(target = nil)
    @target = target
  end

  def update(action)
    @target = nil

    return unless pawn_move?(action)

    moved_path = linear_path_from_positions(action.move_from, action.move_to)

    return unless two_square_move?(moved_path)

    @target = moved_path[1]
  end

  def to_fen_component
    @target.nil? ? '-' : @target.to_s
  end

  private

  def pawn_move?(action)
    [WhitePawn, BlackPawn].include?(action.piece.class) && action.instance_of?(Move)
  end

  def two_square_move?(path)
    path[1..-1].size == 2
  end
end
