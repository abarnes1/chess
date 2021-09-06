# Linked-list type behavior to act like single move (knight) or single move sequence (bishop, rook) that can be stopped at any node
class Move
  attr_accessor :sequence
  attr_reader :start_position

  def initialize(start_position, sequence = [])
    @start_position = start_position
    @sequence = sequence
  end

  def stop_at(stop_position)
    puts "trying to stop move at #{stop_position}"
    stop_index = @sequence.find_index { |position| position == stop_position }

    if stop_index.nil?
      @sequence = []
    else
      @sequence = @sequence[0..stop_index] unless stop_index.nil?
    end
  end

  def to_s
    output = start_position.position

    sequence.each { |pos| output += " -> #{pos.position}"}

    output
  end

  def contains?(position)
    sequence.contains?(position)
  end
end