# frozen_string_literal: true

require_relative 'game_state'
require_relative 'human_player'
require_relative 'computer_player'

# Logic to setup, start, allow moves, and end a game of chess.
class ChessGame
  def initialize
    # require PGN fields in this order
    @event = nil
    @site = nil
    @date = nil
    @round = nil
    @white = 'white'
    @black = 'black'
    @result = nil

    # white turn + black turn
    @rounds = nil

    # optional PGN fields
    @current_fen = nil

    # classes necessary for game to run
    @game_state = nil
    @current_player = nil
  end

  def setup_game
    # create players
    @white = create_player('white')
    @black = create_player('black')
    @current_player = @white
  end

  def create_player(label)
    player_type = ''

    until %w[1 2].include?(player_type)
      print "Choose a player type for #{name} #{token}\nEnter 1 for Human or 2 for Computer: "
      player_type = gets.chomp
    end

    puts ''

    if player_type.eql?('1')
      HumanPlayer.new(label)
    else
      ComputerPlayer.new(label)
    end
  end

  private

  def to_pgn_format
    raise NotImplementedError
  end

  def load_pgn
    # some class to parse PGN and set up internal game state
    raise NotImplementedError
  end

  def switch_player
    @current_player = @current_player == @white ? @black : @white
  end
end
