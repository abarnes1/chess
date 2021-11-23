require_relative 'lib/chess_game'

play_again = ''

until %w[y Y].include?(play_again)
  chess = ChessGame.new
  chess.play_game
end