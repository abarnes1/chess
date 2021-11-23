# frozen_string_literal: true

require_relative 'human_player'
require_relative 'computer_player'

require_relative 'game_state'
require_relative 'game_ending'

require_relative 'modules/piece_sets'

require_relative 'display/chessboard'
require_relative 'terminal_ui'
require_relative 'save_manager'

# Logic to setup, start, allow moves, and end a game of chess.
class ChessGame
  SAVE_FOLDER = 'saves'

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
    ui.display_main_menu
    choice = ui.get_main_menu_choice

    load_game if choice == '2'

    if @game_state.nil?
      create_new_game
    else
      @white = @game_state.white_player
      @black = @game_state.black_player
      @current_player = @game_state.active_player
    end
  end

  def create_player(label, color)
    player_class = ui.get_player_class(label)

    player_class.new(label, color)
  end

  def play_turns
    until game_over?
      ui.update_pieces(game_state.pieces)
      ui.display_game_state(current_player, game_state)
      ui.display_turn_prompt

      play_next_turn(current_player)

      game_end.update(game_state)

      switch_player
    end
  end

  def play_next_turn(player)
    if player.instance_of?(ComputerPlayer)
      play_computer_turn(player)
    else
      play_human_turn(player)
    end
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

  def save_game
    data_manager = SaveManager.new(SAVE_FOLDER)

    filename = Time.now.strftime('%Y-%d-%m_%H-%M-%S')
    ui.display_saving(filename)
    data_manager.save_game(@game_state, filename)

    quit_game
  end

  def load_game
    data_manager = SaveManager.new(SAVE_FOLDER)

    saves = data_manager.saves_list

    if saves.empty?
      ui.display_no_saves
    else
      ui.display_saves(saves)

      save_file = saves[ui.player_input.to_i - 1]

      return if save_file.nil? || save_file.strip.empty?

      @game_state = data_manager.load_game(save_file)
    end
  end

  def quit_game
    ui.display_game_quit
    exit
  end

  private

  def create_new_game
    @white = create_player('white', Colors::GRAY)
    @black = create_player('black', Colors::BLACK)

    self.current_player = white

    @game_state = GameState.new(white: white, black: black)
    standard_piece_setup(game_state)
  end

  def play_computer_turn(player)
    moves = game_state.legal_moves(player)

    # sleep(2)
    chosen_move = player.choose_action(moves)
    puts "#{chosen_move.move_from}#{chosen_move.move_to}"

    @game_state.apply_action(chosen_move)
  end

  def play_human_turn(player)
    moves = game_state.legal_moves(player)

    input = ui.player_input

    until valid_turn_selection(input, moves)
      ui.party_time(player, game_state) if input == 'party time'

      if valid_piece_selection(input, moves)
        piece_moves = piece_moves(input, moves)

        ui.highlight_actions(piece_moves)
        ui.display_game_state(player, game_state)
        ui.display_destination_prompt

        input << ui.player_input
      end

      break if valid_turn_selection(input, moves)

      ui.clear_highlights
      ui.display_game_state(player, game_state)
      ui.display_invalid_selection unless input == 'party time'
      ui.display_turn_prompt
      input = ui.player_input
    end

    save_game if input == 'save'
    quit_game if input == 'quit'

    chosen_move = find_move(input, moves)

    @game_state.apply_action(chosen_move)
  end

  def find_move(input, moves)
    return nil unless input.size == 4

    from = Position.new(input[0..1])
    to = Position.new(input[2..-1])

    moves.find { |move| move.move_from == from and move.move_to == to }
  end

  def piece_moves(input, moves)
    moves.select { |move| move.move_from == Position.new(input) }
  end

  def valid_turn_selection(input, moves)
    selected_move = find_move(input, moves)

    %w[save quit].include?(input) || selected_move
  end

  def valid_piece_selection(input, moves)
    input.size == 2 && moves.any? { |move| move.move_from == Position.new(input) }
  end
end
