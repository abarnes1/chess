require_relative 'game_state'

class GameEnding
  def initialize
    @message = nil
  end

  attr_reader :message

  def update(game_state)
    player = game_state.active_player
    move_count = game_state.legal_moves(player).size

    checkmated?(player, move_count, game_state) unless ending?
    stalemate?(player, move_count, game_state) unless ending?
    half_move_clock?(game_state.half_move_clock) unless ending?
  end

  def ending?
    !@message.nil?
  end

  private

  def checkmated?(player, move_count, game_state)
    winning_player = game_state.opposing_player(player)
    @message = "#{winning_player.name} wins by checkmate!" if move_count.zero? && game_state.in_check?(player)
  end

  def stalemate?(player, move_count, game_state)
    @message = 'Stalemate!' if move_count.zero? && !game_state.in_check?(player)
  end

  def half_move_clock?(half_move_clock)
    @message = 'Draw by half move clock' if half_move_clock > 200
  end
end