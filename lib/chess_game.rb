# frozen_string_literal: true
require_relative 'human_player'
require_relative 'computer_player'

require_relative 'game_state'
require_relative 'game_ending'

require_relative 'pieces/piece_sets'

require_relative 'display/chessboard'
require_relative 'terminal_ui'

# Logic to setup, start, allow moves, and end a game of chess.
class ChessGame
  include PieceSets

  attr_reader :game_over, :ui

  private

  attr_reader :white, :black, :game_state, :game_end
  attr_accessor :current_player

  public

  def initialize
    @white = 'white'
    @black = 'black'

    @game_state = nil
    @current_player = nil
    @winner = nil
    @turn_counter = 0
    @game_end = GameEnding.new

    @ui = TerminalUI.new
  end

  def play_game
    ui.display_intro
    setup_game
    ui.display_chessboard

    play_turns

    end_game
  end

  def setup_game
    # new game or load here
    # create players
    @white = create_player('white', Colors::CYAN)
    @black = create_player('black', Colors::BRIGHT_MAGENTA)
    self.current_player = white

    @game_state = GameState.new(white: white, black: black)
    standard_piece_setup(game_state)
  end

  def create_player(label, color)
    player_class = ui.get_player_class(label)

    player_class.new(label, color)
  end

  def play_turns
    until game_over?
      # system('clear')
      puts "-------- start of turn #{@turn_counter} ---------"

      play_next_turn(current_player)

      ui.update_pieces(game_state.pieces)
      ui.display_chessboard

      switch_player
    end
  end

  def play_next_turn(player)
    moves = game_state.legal_moves(current_player)

    chosen_move = player.choose_action(moves)

    puts "#{current_player.name} #{chosen_move}"
    @game_state.apply_action(chosen_move)

    @turn_counter += 1

    game_end.update(game_state)
  end

  def player_input(player)
    player.choose_action(actions)
  end

  def end_game
    puts game_end.message
  end

  def opposing_player(player = current_player)
    player == white ? black : white
  end

  def switch_player
    self.current_player = opposing_player
  end

  def game_over?
    game_end.ending?
  end
end
