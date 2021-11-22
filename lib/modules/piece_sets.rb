# frozen_string_literal: true

# Preset goups of pieces that can be added to the supplied GameState object.
module PieceSets
  # rubocop:disable Metrics/AbcSize
  def standard_piece_setup(game_state)
    white = game_state.white_player
    black = game_state.black_player

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
  # rubocop:enable Metrics/AbcSize
end
