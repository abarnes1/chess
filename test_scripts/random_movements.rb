require_relative '../lib/modules/positioning'
require_relative '../lib/game_state'
require_relative '../lib/chessboard'

game_state = GameState.new
player1 = { color: Colors::CYAN, description: 'cyan' }
player2 = { color: Colors::BRIGHT_MAGENTA, description: 'magenta'}

a8 = Rook.new(position: Position.new('a8'), owner: player1)
b8 = Knight.new(position: Position.new('b8'), owner: player1)
c8 = Bishop.new(position: Position.new('c8'), owner: player1)
d8 = Queen.new(position: Position.new('d8'), owner: player1)
e8 = King.new(position: Position.new('e8'), owner: player1)
f8 = Bishop.new(position: Position.new('f8'), owner: player1)
g8 = Knight.new(position: Position.new('g8'), owner: player1)
h8 = Rook.new(position: Position.new('h8'), owner: player1)

a7 = BlackPawn.new(position: Position.new('a7'), owner: player1)
b7 = BlackPawn.new(position: Position.new('b7'), owner: player1)
c7 = BlackPawn.new(position: Position.new('c7'), owner: player1)
d7 = BlackPawn.new(position: Position.new('d7'), owner: player1)
e7 = BlackPawn.new(position: Position.new('e7'), owner: player1)
f7 = BlackPawn.new(position: Position.new('f7'), owner: player1)
g7 = BlackPawn.new(position: Position.new('g7'), owner: player1)
h7 = BlackPawn.new(position: Position.new('h7'), owner: player1)

game_state.add_piece(a8)
game_state.add_piece(b8)
game_state.add_piece(c8)
game_state.add_piece(d8)
game_state.add_piece(e8)
game_state.add_piece(f8)
game_state.add_piece(g8)
game_state.add_piece(h8)

game_state.add_piece(a7)
game_state.add_piece(b7)
game_state.add_piece(c7)
game_state.add_piece(d7)
game_state.add_piece(e7)
game_state.add_piece(f7)
game_state.add_piece(g7)
game_state.add_piece(h7)
####
a1 = Rook.new(position: Position.new('a1'), owner: player2)
b1 = Knight.new(position: Position.new('b1'), owner: player2)
c1 = Bishop.new(position: Position.new('c1'), owner: player2)
d1 = Queen.new(position: Position.new('d1'), owner: player2)
e1 = King.new(position: Position.new('e1'), owner: player2)
f1 = Bishop.new(position: Position.new('f1'), owner: player2)
g1 = Knight.new(position: Position.new('g1'), owner: player2)
h1 = Rook.new(position: Position.new('h1'), owner: player2)

a2 = WhitePawn.new(position: Position.new('a2'), owner: player2)
b2 = WhitePawn.new(position: Position.new('b2'), owner: player2)
c2 = WhitePawn.new(position: Position.new('c2'), owner: player2)
d2 = WhitePawn.new(position: Position.new('d2'), owner: player2)
e2 = WhitePawn.new(position: Position.new('e2'), owner: player2)
f2 = WhitePawn.new(position: Position.new('f2'), owner: player2)
g2 = WhitePawn.new(position: Position.new('g2'), owner: player2)
h2 = WhitePawn.new(position: Position.new('h2'), owner: player2)

game_state.add_piece(a1)
game_state.add_piece(b1)
game_state.add_piece(c1)
game_state.add_piece(d1)
game_state.add_piece(e1)
game_state.add_piece(f1)
game_state.add_piece(g1)
game_state.add_piece(h1)

game_state.add_piece(a2)
game_state.add_piece(b2)
game_state.add_piece(c2)
game_state.add_piece(d2)
game_state.add_piece(e2)
game_state.add_piece(f2)
game_state.add_piece(g2)
game_state.add_piece(h2)

@board = Chessboard.new
@board.display_pieces(game_state.pieces)
puts @board.display

def player_for_turn(counter, players)
  counter.even? ? players[0] : players[1]
end

def output_board(game_state)
  @board.reset_squares
  @board.display_pieces(game_state.pieces)
  puts @board.display
end

def take_turn(player, game_state)
  pieces = game_state.friendly_pieces(player)

  valid_move_made = false

  until valid_move_made

    moves = []

    pieces.each { |piece| moves << ActionFactory.actions_for(piece, game_state)}

    # if moves.empty?
    #   "no valid moves found? I guess it's over now"
    #   break
    # end
    random_move = moves.flatten!.compact.shuffle!.shift

    # puts "trying #{random_move}"
    # puts "included? #{moves.include?(random_move)}"

    if random_move.respond_to?(:promote_to)
      random_move.promote_to = Queen.new(position: random_move.move_to, owner: player)
    end

    until valid_move_made
      game_state.apply_action(random_move)

      if game_state.legal_state?(player)
        valid_move_made = true
      else
        game_state.undo_last_action

        if moves.empty?
          if game_state.in_check?(player)
            puts "#{player[:description]} has been checkmated!"
          else
            puts "stalemate!"
          end

          abort
        end

        # puts "#{moves.size} moves left, trying another"
        # puts "moves is a #{moves.class}"
        # puts "random_move is a #{random_move.class}"
        random_move = moves.shift
        # puts "random_move is a #{random_move.class}"
      end
    end

    valid_move_made = true

    if valid_move_made
      # puts random_move.to_s
      output_board(game_state)

      puts "#{player[:description]} #{random_move}"

      puts "moves logged: #{game_state.action_log.size}" if valid_move_made

      if [EnPassant, Castling].include?(random_move.class)
        # puts 'aborting: something interesting happened!'
        # abort
      end
    end
  end
end

players = [player1, player2]

counter = 0

# puts "player: #{player_for_turn(counter, players)}"

until counter >= 300 do
  player = player_for_turn(counter, players) 
  take_turn(player, game_state)

  # sleep 2
  # system("clear")

  counter += 1
end
