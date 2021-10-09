# frozen_string_literal: true

require_relative 'chesspiece'

# Pawns that traditonally start on rank 7 for the black player.
class BlackPawn < ChessPiece
  include Positioning

  def initialize(icon: "\u265F", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @notation_letter = 'P'
  end

  def move_offsets
    if position.rank == '7'
      [RepeatOffset.new([0, -1], 2)]
    else
      [Offset.new([0, -1])]
    end
  end

  def capture_offsets
    [
      Offset.new([-1, -1]), 
      Offset.new([1, -1])
    ]
  end

  def can_promote_at?(position)
    position.rank == '1'
  end

  def can_en_passant?(game_state)
    previous_move = game_state.last_moves(1)[0]

    return false if previous_move.nil?

    if previous_move.piece.is_a?(WhitePawn) && valid_en_passant_target(previous_move)
      true
    else
      false
    end
  end

  private

  def valid_en_passant_target(last_move)
    passed_my_capture?(last_move) && neighbor_by_file?(last_move.piece) && last_move.piece.owner != owner
  end

  def passed_my_capture?(last_move)
    (position.rank.to_i - last_move.move_from.rank.to_i) == 2
  end

  def neighbor_by_file?(piece)
    enemy_file = piece.position.file.ord
    my_file = position.file.ord

    (enemy_file - my_file).abs == 1
  end
end
