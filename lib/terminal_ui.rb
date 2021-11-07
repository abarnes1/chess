require_relative 'display/chessboard'

class TerminalUI
  def initialize
    @chessboard = Chessboard.new
  end

  def display_intro
    puts 'Play some Chess!'
  end

  def update_pieces(pieces)
    chessboard.display_pieces(pieces)
  end

  def display_chessboard
    puts chessboard.display
  end

  private

  attr_reader :chessboard
end