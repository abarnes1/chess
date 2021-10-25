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
    @winner = nil
  end

  def play_game
    print_intro
    setup_game
    puts @gameboard.to_s

    play_turns
    end_game
  end

  def setup_game
    # create players
    @white = create_player('white', Colors::CYAN)
    @black = create_player('black', Colors::BRIGHT_MAGENTA)
    @current_player = @white

    @game_state = GameState.standard_pieces(@white, @black)
  end

  def create_player(label)
    player_type = ''

    until %w[1 2].include?(player_type)
      print "Choose a player type for #{label}\nEnter 1 for Human or 2 for Computer: "
      player_type = gets.chomp
    end

    puts ''

    if player_type.eql?('1')
      HumanPlayer.new(label)
    else
      ComputerPlayer.new(label)
    end
  end

  def play_turns
    until game_over?
      play_next_turn(@current_player)
      puts @gameboard.to_s

      @winner = @current_player if game_won?

      switch_player if @winner.nil?
    end
  end

  def play_next_turn(player)
    # input = player_input(player)
    # @last_move_identifier = @gameboard.drop(input, player.token)
  end

  def player_input(player)
    # column = nil

    # until valid_move?(column)
    #   if player.instance_of?(HumanPlayer)
    #     print "Choose a column for #{player.name} #{player.token} : "
    #     column = gets.chomp.to_i
    #   elsif player.instance_of?(ComputerPlayer)
    #     sleep(1)
    #     column = player.choose_move(@gameboard.valid_moves)
    #     puts "#{player.name} #{player.token}  chooses column ##{column}"
    #   end
    # end

    # column
  end

  def game_won?

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

  def print_intro
    puts 'Play some chess.'
  end
  
  def standard_piece_setup
    @game_state.add_piece(Rook.new(position: Position.new('a1'), owner: @white))
    @game_state.add_piece(Knight.new(position: Position.new('b1'), owner: @white))
    @game_state.add_piece(Bishop.new(position: Position.new('c1'), owner: @white))
    @game_state.add_piece(Queen.new(position: Position.new('d1'), owner: @white))
    @game_state.add_piece(King.new(position: Position.new('e1'), owner: @white))
    @game_state.add_piece(Bishop.new(position: Position.new('f1'), owner: @white))
    @game_state.add_piece(Knight.new(position: Position.new('g1'), owner: @white))
    @game_state.add_piece(Rook.new(position: Position.new('h1'), owner: @white))

    @game_state.add_piece(WhitePawn.new(position: Position.new('a2'), owner: @white))
    @game_state.add_piece(WhitePawn.new(position: Position.new('b2'), owner: @white))
    @game_state.add_piece(WhitePawn.new(position: Position.new('c2'), owner: @white))
    @game_state.add_piece(WhitePawn.new(position: Position.new('d2'), owner: @white))
    @game_state.add_piece(WhitePawn.new(position: Position.new('e2'), owner: @white))
    @game_state.add_piece(WhitePawn.new(position: Position.new('f2'), owner: @white))
    @game_state.add_piece(WhitePawn.new(position: Position.new('g2'), owner: @white))
    @game_state.add_piece(WhitePawn.new(position: Position.new('h2'), owner: @white))

    @game_state.add_piece(Rook.new(position: Position.new('a8'), owner: @black))
    @game_state.add_piece(Knight.new(position: Position.new('b8'), owner: @black))
    @game_state.add_piece(Bishop.new(position: Position.new('c8'), owner: @black))
    @game_state.add_piece(Queen.new(position: Position.new('d8'), owner: @black))
    @game_state.add_piece(King.new(position: Position.new('e8'), owner: @black))
    @game_state.add_piece(Bishop.new(position: Position.new('f8'), owner: @black))
    @game_state.add_piece(Knight.new(position: Position.new('g8'), owner: @black))
    @game_state.add_piece(Rook.new(position: Position.new('h8'), owner: @black))

    @game_state.add_piece(BlackPawn.new(position: Position.new('a7'), owner: @black))
    @game_state.add_piece(BlackPawn.new(position: Position.new('b7'), owner: @black))
    @game_state.add_piece(BlackPawn.new(position: Position.new('c7'), owner: @black))
    @game_state.add_piece(BlackPawn.new(position: Position.new('d7'), owner: @black))
    @game_state.add_piece(BlackPawn.new(position: Position.new('e7'), owner: @black))
    @game_state.add_piece(BlackPawn.new(position: Position.new('f7'), owner: @black))
    @game_state.add_piece(BlackPawn.new(position: Position.new('g7'), owner: @black))
    @game_state.add_piece(BlackPawn.new(position: Position.new('h7'), owner: @black))
  end
end
