#
class ChessPiece
  attr_reader :position, :algebraic_letter

  def initialize(icon: 'X', position: nil, owner: nil)
    @icon = icon.freeze
    @owner = owner
    @position = position
    @algebraic_letter = 'X'.freeze
  end

  def possible_moves
    raise NotImplementedError
  end

  def to_s
    @icon
  end
end
