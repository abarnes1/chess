require_relative 'action'

class Capture < Action
  def initialize(piece = nil, move_from = nil, move_to = nil, captured)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    @captured = captured
    puts "capture initialize: #{@piece} from #{move_from} to #{move_to} and capture #{captured}"
  end

  def apply(board)
    # actually moving the pieces
  end
end
