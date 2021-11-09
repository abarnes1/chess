require_relative 'game_state'

class GameEnding
  def initialize
    @message = nil
    @winner = nil
  end

  attr_reader :message, :winner

  def update(game_state)
    player = game_state.active_player
    move_count = game_state.legal_moves(player).size

    checkmated?(player, move_count, game_state) unless ending?
    stalemate?(player, move_count, game_state) unless ending?
    half_move_clock?(game_state.half_move_clock) unless ending?
    king_bishop_vs_king_bishop_same_color?(game_state) unless ending?
    king_vs_king_bishop?(game_state) unless ending?
    king_vs_king_knight?(game_state) unless ending?
    king_vs_king?(game_state) unless ending?
  end

  def ending?
    !@message.nil?
  end

  private

  def checkmated?(player, move_count, game_state)
    @winner = game_state.opposing_player(player)
    @message = "#{winner.name} wins by checkmate!" if move_count.zero? && game_state.in_check?(player)
  end

  def stalemate?(player, move_count, game_state)
    @message = 'Stalemate!' if move_count.zero? && !game_state.in_check?(player)
  end

  def half_move_clock?(half_move_clock)
    @message = 'Draw by 75 move rule' if half_move_clock > 75
  end

  def king_vs_king?(game_state)
    player = game_state.active_player
    other_player = game_state.opposing_player(player)

    pieces = game_state.player_pieces(player)
    other_pieces = game_state.player_pieces(other_player)

    @message = 'Draw due to dead position (K vs. K)' if only_king?(pieces) && only_king?(other_pieces)
  end

  def king_vs_king_bishop?(game_state)
    player = game_state.active_player
    other_player = game_state.opposing_player(player)

    pieces = game_state.player_pieces(player)
    other_pieces = game_state.player_pieces(other_player)

    if (only_king?(pieces) && only_king_bishop?(other_pieces)) ||
       (only_king?(other_pieces) && only_king_bishop?(pieces))
      @message = 'Draw due to dead position (K vs. KB)' 
    end
  end

  def king_vs_king_knight?(game_state)
    player = game_state.active_player
    other_player = game_state.opposing_player(player)

    pieces = game_state.player_pieces(player)
    other_pieces = game_state.player_pieces(other_player)

    if (only_king?(pieces) && only_king_knight?(other_pieces)) ||
       (only_king?(other_pieces) && only_king_knight?(pieces))
      @message = 'Draw due to dead position (K vs. KN)' 
    end
  end

  def king_bishop_vs_king_bishop_same_color?(game_state)
    player = game_state.active_player
    other_player = game_state.opposing_player(player)

    pieces = game_state.player_pieces(player)
    other_pieces = game_state.player_pieces(other_player)

    if (only_king_bishop?(pieces) && only_king_bishop?(other_pieces))
      bishop_one = find_bishop(pieces)
      bishop_two = find_bishop(other_pieces)

      if (bishop_one.position.white_square? && bishop_two.position.white_square?) ||
         (bishop_one.position.black_square? && bishop_two.position.black_square?)
          @message = 'Draw due to dead position (KB vs. KB, same color B)' 
      end
    end
  end

  def only_king_bishop?(pieces)
    return false if pieces.size != 2

    bishop_count = pieces.select { |piece| piece.instance_of?(Bishop) }.size
    king_count = pieces.select { |piece| piece.instance_of?(King) }.size

    bishop_count == 1 && king_count == 1
  end

  def only_king_knight?(pieces)
    return false if pieces.size != 2

    knight_count = pieces.select { |piece| piece.instance_of?(Knight) }.size
    king_count = pieces.select { |piece| piece.instance_of?(King) }.size

    knight_count == 1 && king_count == 1
  end

  def only_king?(pieces)
    pieces.size == 1 && pieces.all? { |piece| piece.instance_of?(King)}
  end

  def find_bishop(pieces)
    bishop = pieces.find { |piece| piece.instance_of?(Bishop)}
  end
end