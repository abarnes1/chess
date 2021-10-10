require_relative 'lib/modules/positioning'
require_relative 'lib/game_state'
require_relative 'lib/chessboard'

rook = Rook.new(position: Position.new('c4'), owner: { color: Colors::CYAN} )
enemy_one = BlackPawn.new(position: Position.new('b4'), owner: { color: Colors::BRIGHT_MAGENTA} )
enemy_two = BlackPawn.new(position: Position.new('c2'), owner: { color: Colors::BRIGHT_MAGENTA} )
enemy_three = BlackPawn.new(position: Position.new('c5'), owner: { color: Colors::BRIGHT_MAGENTA} )
enemy_four = BlackPawn.new(position: Position.new('f4'), owner: { color: Colors::BRIGHT_MAGENTA} )

game_state = GameState.new
game_state.add_piece(rook)
game_state.add_piece(enemy_one)
game_state.add_piece(enemy_two)
game_state.add_piece(enemy_three)
game_state.add_piece(enemy_four)

# Get the rook's actions by supplying the game state.
# This is a wrapper for ActionFactory.actions_for.
actions_from_piece = rook.actions(game_state)

# Gets the same actions a different way.  Anytime the base
# Action class is inherited from, ActionFactory will call the 
# inherited class's #create_for and add those moves to the
# returned Array.
actions_from_factory = ActionFactory.actions_for(rook, game_state)

# Rook will only ever produce Move and Capture class actions.
# Create only those action types.
rook_moves = Move.create_for(rook, game_state)
rook_captures = Capture.create_for(rook, game_state)
actions_from_individual_classes = rook_moves + rook_captures

actions_from_piece.each { |action| puts action }
puts '*' * 20
actions_from_factory.each { |action| puts action }
puts '*' * 20
actions_from_individual_classes.each { |action| puts action }
puts '*' * 20

# ^ Lost on which one of the above I should be calling for tests.

board = Chessboard.new
board.display_pieces(game_state.pieces)
board.highlight_actions(actions_from_piece)

puts board.display
