class HalfMoveClock
  attr_reader :counter

  def initialize(counter = 0)
    @counter = counter
  end

  def update(action)
    if  capture?(action) || pawn_move?(action)
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