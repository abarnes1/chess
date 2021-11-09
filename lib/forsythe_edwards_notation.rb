module ForsytheEdwardsNotation
  def full_fen
    values = []
    values << board_data.to_fen_component
    values << active_player_fen
    values << castling_rights.to_fen_component
    values << en_passant_target.to_fen_component
    values << full_move_counter
    values << half_move_clock

    values.join(' ')
  end

  def repetition_fen
    values = []
    values << board_data.to_fen_component
    values << active_player_fen
    values << castling_rights.to_fen_component
    values << en_passant_target.to_fen_component

    values.join(' ')
  end

  private

  def active_player_fen
    active_player == white_player ? 'w' : 'b'
  end
end
