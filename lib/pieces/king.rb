# frozen_string_literal: true

require_relative 'chesspiece'
require_relative '../modules/positioning'

# Standard king for a game of chess.  Handles special moves,
# like castling, for white and black.
class King < ChessPiece
  include Positioning

  def initialize(icon: "\u265A", position: nil, owner: nil)
    super(icon: icon, position: position, owner: owner)

    @offsets = [
      Offset.new([-1, -1]),
      Offset.new([-1, 1]),
      Offset.new([-1, 0]),
      Offset.new([1, 0]),
      Offset.new([1, -1]),
      Offset.new([1, 1]),
      Offset.new([0, -1]),
      Offset.new([0, 1])
    ]

    @notation_letter = 'K'
  end

  def can_be_checked?
    true
  end

  def can_castle?(game_state)
    return false if game_state.moved?(self) || !valid_castling_position?

    puts "#{self} can castle, looking for valid partners"

    partners = castling_partners(game_state)

    return false if partners.nil? || partners.size.zero?

    true
  end

  def castling_partners(game_state)
    valid_positions = valid_partner_positions

    potential_partners = potential_castling_partners(game_state)

    valid_castle_partners = potential_partners.select do |piece|
      valid_positions.include?(piece.position) &&
        !game_state.moved?(piece)
    end

    puts "found #{valid_castle_partners.size} castling partners"

    valid_castle_partners.select { |partner| castling_path_valid?(game_state, partner) }
  end

  private

  def valid_castling_position?
    [Position.new('e1'), Position.new('e8')].include? position
  end

  def potential_castling_partners(game_state)
    potential_partners = game_state.friendly_pieces(owner)
    potential_partners.select(&:castling_partner?)
  end

  def castling_path_valid?(game_state, partner_piece)
    if partner_piece.position == Position.new("a#{position.rank}")
      castling_valid_left?(game_state, partner_piece)
    elsif partner_piece.position == Position.new("h#{position.rank}")
      castling_valid_right?(game_state, partner_piece)
    else
      false
    end
  end

  def castling_valid_left?(game_state, _partner_piece)
    blocked = game_state.occupied_at?(Position.new("b#{position.rank}")) ||
              game_state.occupied_at?(Position.new("c#{position.rank}")) ||
              game_state.occupied_at?(Position.new("d#{position.rank}"))

    crosses_attackable_square = game_state.attackable_by_enemy?(owner, Position.new("c#{position.rank}")) ||
                                game_state.attackable_by_enemy?(owner, Position.new("d#{position.rank}"))

    !crosses_attackable_square && !blocked
  end

  def castling_valid_right?(game_state, _partner_piece)
    blocked = game_state.occupied_at?(Position.new("f#{position.rank}")) ||
              game_state.occupied_at?(Position.new("g#{position.rank}"))

    crosses_attackable_square = game_state.attackable_by_enemy?(owner, Position.new("f#{position.rank}")) ||
                                game_state.attackable_by_enemy?(owner, Position.new("g#{position.rank}"))

    !crosses_attackable_square && !blocked
  end

  def valid_partner_positions
    if position == Position.new('e1')
      [Position.new('a1'), Position.new('h1')]
    elsif position == Position.new('e8')
      [Position.new('a8'), Position.new('h8')]
    end
  end
end
