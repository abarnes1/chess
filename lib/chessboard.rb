require_relative 'chess_square'

class Chessboard
  def initialize
    @squares = nil
  end

  def squares
    initialize_squares if @squares.nil?

    @squares
  end

  def display
    output = ''
    ranks = ('a'..'h').to_a

    ranks.each do |rank|
      output += "#{rank} "
      row = squares.select { |square| square.rank == rank }

      row.reverse.each { |item| output += "#{item.position} " }
      output += "\n"
    end

    output += "  1  2  3  4  5  6  7  8\n"
  end

  private

  def initialize_squares
    @squares = Array.new(64)
    ranks = ('a'..'h').to_a
    files = ('1'..'8').to_a
    positions = ranks.product(files).map { |pair| pair.join }

    @squares.each_index do |index|
      rank = positions[index][0]
      file = positions[index][1]
      squares[index] = ChessSquare.new(rank, file)
    end
  end
end