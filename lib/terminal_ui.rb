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

  def get_player_class(description)
    player_class = nil

    until player_class
      print "Choose a player type for #{description}\nEnter 1 for Human or 2 for Computer: "
      player_class = player_class_lookup(gets.chomp)
    end

    player_class
  end

  def display_game_end(message)
    system('clear')
    display_chessboard
    puts message
  end

  def display_turn_start(player, in_check)
    system('clear')
    display_chessboard
    puts in_check ? "#{player.name}'s turn. You're in check!" : "#{player.name}'s turn."
    print "Enter save, quit, or select a piece's location: "
  end

  def player_turn_input
    gets.chomp.downcase
  end

  def display_invalid_selection
    print "That's not valid... try again: "
  end

  private

  attr_reader :chessboard

  def player_class_lookup(input)
    case input
    when '1'
      HumanPlayer
    when '2'
      ComputerPlayer
    end
  end
end