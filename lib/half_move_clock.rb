# frozen_string_literal: true

# Represents the half move clock in chess that is used to determine draws
# due to a series of moves that are done done by Pawns or do not result
# in a piece being captured.
class HalfMoveClock
  attr_reader :counter

  def initialize(counter = 0)
    @counter = counter
  end

  def update(action)
    if capture?(action) || pawn_move?(action)
      @counter = 0
    else
      @counter += 1
    end
  end

  def capture?(action)
    [Capture, PromoteCapture].include?(action.class)
  end

  def pawn_move?(action)
    [WhitePawn, BlackPawn].include?(action.piece.class)
  end
end
