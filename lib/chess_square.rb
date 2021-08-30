class ChessSquare
  attr_accessor :piece
  attr_reader :rank, :file

  def initialize(rank, file)
    @rank = rank
    @file = file
    @piece = nil
  end

  def position
    "#{rank}#{file}"
  end
end