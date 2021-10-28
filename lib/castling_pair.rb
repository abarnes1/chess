class CastlingPair
  def initialize(king_position, rook_position)
    @positions = [king_position, rook_position]

    @enabled = true
  end

  def enabled?
    @enabled
  end

  def update(position_moved_from)
    @enabled = false if @positions.any? { |position| position == position_moved_from}
  end
end