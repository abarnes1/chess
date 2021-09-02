require_relative 'chess_square'
require_relative 'colors'

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
    ranks = ('1'..'8').to_a.reverse

    ranks.each_with_index do |rank, index|
      output += "#{(index - 8).abs} "
      row = squares.select { |square| square.rank == rank }

      row.each { |item| output += item.to_s }
      output += "\n"
    end

    output += "  a b c d e f g h\n"
  end

  def select(position)
    @squares.find { |square| square.position == position }
  end

  private

  def initialize_squares
    @squares = Array.new(64)
    ranks = ('1'..'8').to_a
    files = ('a'..'h').to_a
    positions = ranks.product(files).map { |pair| pair.join }

    @squares.each_index do |index|
      rank = positions[index][0]
      file = positions[index][1]
      colors = (file.ord + rank.to_i) % 2 == 0 ? {bg_color: Colors::BG_BLACK} : {bg_color: Colors::BG_BRIGHT_GRAY}

      square = ChessSquare.new(rank, file, colors)
      squares[index] = square
    end
  end
end