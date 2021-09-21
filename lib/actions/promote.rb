require_relative 'action'

class Promote < Action
  attr_accessor :promote_to
  attr_reader :move_to, :piece
  def initialize(piece = nil, promote_to = '?', move_to)
    super
    @piece = piece
    @promote_to = promote_to
    @move_to = move_to

    puts "initializing #{self}"
  end

  def apply(board)
    # actually moving the pieces
  end

  def to_s
    "promote: #{@piece} to #{@promote_to} at #{@move_to}"
  end

  def notation
    "#{@move_to}#{@promote_to}"
  end
end