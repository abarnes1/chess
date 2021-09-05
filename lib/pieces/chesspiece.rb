#
class ChessPiece
  attr_reader :position

  def initialize(icon: 'X', position: nil, owner: nil)
    @icon = icon.freeze
    @owner = owner
    @position = position
  end

  def possible_moves
    raise NotImplementedError
  end

  def to_s
    @icon
  end
end
