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
      ui.update_pieces(game_state.pieces)
      ui.display_turn_start(current_player, game_state.in_check?(current_player))

      play_next_turn(current_player)

      switch_player
    end
  end

  def play_next_turn(player)
    moves = game_state.legal_moves(current_player)

    chosen_move = if player.instance_of?(ComputerPlayer)
                    player.choose_action(moves)
                  else
                    input = ui.player_turn_input

                    until valid_turn_selection(input, moves)
                      ui.display_invalid_selection
                      input = ui.player_turn_input
                    end

                    save_game if input == 'save'
                    quit_game if input == 'quit'

                    find_move(input, moves)
                  end

    puts "#{current_player.name} #{chosen_move}"
    @game_state.apply_action(chosen_move)

    game_end.update(game_state)
  end

  def end_game
    ui.update_pieces(game_state.pieces)
    ui.display_game_end(game_end.message) if game_over?
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

  private

  def find_move(input, moves)
    return nil unless input.size == 4

    from = Position.new(input[0..1])
    to = Position.new(input[2..-1])

    moves.find { |move| move.move_from == from and move.move_to == to }
  end

  def valid_turn_selection(input, moves)
    selected_move = find_move(input, moves)

    %w[save quit].include?(input) || selected_move
  end
end
