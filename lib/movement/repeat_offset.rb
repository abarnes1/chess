require_relative 'offset'

class RepeatOffset < Offset
  def initialize(coordinate, max_repeats = 100)
    super(coordinate)

    @max_repeats = max_repeats
  end

  def continue?(counter)
    counter < @max_repeats
  end
end
