# frozen_string_literal: true

require_relative 'game_state'
require_relative 'human_player'
require_relative 'computer_player'
require_relative 'display/chessboard'
require_relative 'terminal_ui'

# Logic to setup, start, allow moves, and end a game of chess.
class ChessGame
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
    puts @chessboard.to_s

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
    standard_piece_setup
  end

  def create_player(label, color)
    player_type = ''

    until %w[1 2].include?(player_type)
      print "Choose a player type for #{label}\nEnter 1 for Human or 2 for Computer: "
      player_type = gets.chomp
    end

    puts ''

    if player_type.eql?('1')
      HumanPlayer.new(label, color)
    else
      ComputerPlayer.new(label, color)
    end
  end

  def play_turns
    until @game_over
      # system('clear')

      ui.update_pieces(game_state.pieces)
      ui.display_chessboard

      play_next_turn(@current_player)

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

  def opposing_player(player = @current_player)
    player == white ? black : white
  end

  def print_intro
    puts 'Play some chess.'
  end

  def switch_player
    @current_player = opposing_player
  end

  private

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

  def standard_piece_setup
    game_state.add_piece(Rook.new(position: Position.new('a1'), owner: white))
    game_state.add_piece(Knight.new(position: Position.new('b1'), owner: white))
    game_state.add_piece(Bishop.new(position: Position.new('c1'), owner: white))
    game_state.add_piece(Queen.new(position: Position.new('d1'), owner: white))
    game_state.add_piece(King.new(position: Position.new('e1'), owner: white))
    game_state.add_piece(Bishop.new(position: Position.new('f1'), owner: white))
    game_state.add_piece(Knight.new(position: Position.new('g1'), owner: white))
    game_state.add_piece(Rook.new(position: Position.new('h1'), owner: white))

    game_state.add_piece(WhitePawn.new(position: Position.new('a2'), owner: white))
    game_state.add_piece(WhitePawn.new(position: Position.new('b2'), owner: white))
    game_state.add_piece(WhitePawn.new(position: Position.new('c2'), owner: white))
    game_state.add_piece(WhitePawn.new(position: Position.new('d2'), owner: white))
    game_state.add_piece(WhitePawn.new(position: Position.new('e2'), owner: white))
    game_state.add_piece(WhitePawn.new(position: Position.new('f2'), owner: white))
    game_state.add_piece(WhitePawn.new(position: Position.new('g2'), owner: white))
    game_state.add_piece(WhitePawn.new(position: Position.new('h2'), owner: white))

    game_state.add_piece(Rook.new(position: Position.new('a8'), owner: black))
    game_state.add_piece(Knight.new(position: Position.new('b8'), owner: black))
    game_state.add_piece(Bishop.new(position: Position.new('c8'), owner: black))
    game_state.add_piece(Queen.new(position: Position.new('d8'), owner: black))
    game_state.add_piece(King.new(position: Position.new('e8'), owner: black))
    game_state.add_piece(Bishop.new(position: Position.new('f8'), owner: black))
    game_state.add_piece(Knight.new(position: Position.new('g8'), owner: black))
    game_state.add_piece(Rook.new(position: Position.new('h8'), owner: black))

    game_state.add_piece(BlackPawn.new(position: Position.new('a7'), owner: black))
    game_state.add_piece(BlackPawn.new(position: Position.new('b7'), owner: black))
    game_state.add_piece(BlackPawn.new(position: Position.new('c7'), owner: black))
    game_state.add_piece(BlackPawn.new(position: Position.new('d7'), owner: black))
    game_state.add_piece(BlackPawn.new(position: Position.new('e7'), owner: black))
    game_state.add_piece(BlackPawn.new(position: Position.new('f7'), owner: black))
    game_state.add_piece(BlackPawn.new(position: Position.new('g7'), owner: black))
    game_state.add_piece(BlackPawn.new(position: Position.new('h7'), owner: black))
  end
end
