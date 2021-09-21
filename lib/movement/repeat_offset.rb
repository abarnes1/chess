require_relative 'offset'

class RepeatOffset < Offset
  attr_reader :max_repeats

  def initialize(coordinate, max_repeats = 777)
    super(coordinate)

    @max_repeats = max_repeats
  end

  def continue?(counter)
    counter < @max_repeats
  end
end
