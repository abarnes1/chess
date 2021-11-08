# frozen_string_literal: true

require_relative 'game_state'
require_relative 'human_player'
require_relative 'computer_player'
require_relative 'display/chessboard'
require_relative 'terminal_ui'
require_relative 'pieces/piece_sets'

# Logic to setup, start, allow moves, and end a game of chess.
class ChessGame
  include PieceSets

  attr_reader :game_over, :ui

  def initialize
    @white = 'white'
    @black = 'black'

    @game_state = nil
    @current_player = nil
    @winner = nil
    @turn_counter = 0
    @game_over = false

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
    @current_player = white

    @game_state = GameState.new(white: white, black: black)
    standard_piece_setup(game_state)
  end

  def create_player(label, color)
    player_class = ui.get_player_class(label)

    player_class.new(label, color)
  end

  def play_turns
    until @game_over
      # system('clear')

      ui.update_pieces(game_state.pieces)
      ui.display_chessboard

      play_next_turn(current_player)

      switch_player
    end
  end

  def play_next_turn(player)
    puts "-------- start of turn #{@turn_counter} ---------"
    moves = game_state.legal_moves(@current_player)

    update_game_over_status(@current_player, moves.size)

    return if game_over

    chosen_move = player.choose_action(moves)

    puts "#{@current_player.name} #{chosen_move}"
    @game_state.apply_action(chosen_move)

    @turn_counter += 1
  end

  def player_input(player)
    player.choose_action(actions)
  end

  def end_game
    puts @ending_message
  end

  def opposing_player(player = current_player)
    player == white ? black : white
  end

  def switch_player
    @current_player = opposing_player
  end

  private

  attr_accessor :current_player
  attr_reader :game_state, :white, :black

  def update_game_over_status(player, move_count)
    return unless move_count.zero? || @turn_counter >= 200

    if @game_state.in_check?(player)
      @winner = opposing_player(player)
      @ending_message = "checkmate, #{@winner.name} wins!"
    elsif @turn_counter >= 200
      @ending_message = 'draw, too many turns'
    else
      @ending_message = 'stalemate'
    end

    @game_over = true
  end
end
