require_relative 'action'

class Move < Action
  def initialize(piece = nil, move_from = nil, move_to = nil)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    puts "move initialize: #{@piece} from #{move_from} to #{move_to}"
  end

  def apply(board)
    # actually moving the pieces
  end
end
