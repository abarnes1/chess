# frozen_string_literal: true

require_relative 'display/chessboard'

# User interface to play a game of chess in the terminal.
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
      print "\nChoose a player type for #{description}\nEnter 1 for Human or 2 for Computer: "
      player_class = player_class_lookup(gets.chomp)
    end

    player_class
  end

  def get_main_menu_choice
    save_load_choice = player_input

    until %w[1 2].include?(save_load_choice)
      display_invalid_selection
      display_main_menu
      save_load_choice = player_input
    end

    save_load_choice
  end

  def display_game_end(message)
    system('clear')
    display_chessboard
    puts message
  end

  def display_turn_prompt
    print 'Enter save, quit, a piece (a2), or a move (a2a4): '
  end

  def display_destination_prompt
    print 'Enter the destination square: '
  end

  def display_game_state(player, game_state)
    system('clear')
    display_chessboard
    puts game_state.in_check?(player) ? "#{player.name}'s turn. You're in check!" : "#{player.name}'s turn."
  end

  def player_input
    gets.chomp.downcase
  end

  def display_invalid_selection
    puts "\e[31mThat's not valid... try again.\e[0m"
  end

  def display_main_menu
    print 'Enter 1 to start a new game or 2 to load a saved game: '
  end

  def display_saves(saves)
    puts 'Listing saved games: '

    saves.compact.each_with_index { |save, index| puts "#{index + 1}: #{save}" }

    print 'Select a file number to load or nothing to create a new game: '
  end

  def display_no_saves
    puts "There are no saves games to display.\n"
  end

  def display_saving(filename)
    puts "Saving your game in file: #{filename}"
  end

  def display_game_quit
    puts 'Quitting... Thanks for playing!'
  end

  def highlight_actions(actions)
    chessboard.highlight_actions(actions)
  end

  def clear_highlights
    chessboard.clear_highlights
  end

  def party_time(player, game_state)
    20.times do
      @chessboard.randomize_background_colors
      display_game_state(player, game_state)
      puts "It's party time y'all!"
      sleep(0.25)
    end

    chessboard.reset_color_scheme
    display_game_state(player, game_state)
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
