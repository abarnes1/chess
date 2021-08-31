#
class ChessPiece
  attr_reader :position

  def initialize(position = nil, owner = nil)
    @owner = owner
    @position = position
  end

  def possible_moves
    raise NotImplementedError
  end
end
