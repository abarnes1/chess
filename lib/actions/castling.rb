# frozen_string_literal: true

require_relative 'action'

# Castling chess action between a piece that
# initiates castling and a partner piece.
class Castling < Action
  attr_accessor :piece, :move_from, :move_to, :partner_piece, :partner_move_from, :partner_move_to

  def initialize(piece, move_from, move_to, partner_piece, partner_move_to)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    @partner_piece = partner_piece
    @partner_move_from = partner_piece.position
    @partner_move_to = partner_move_to
  end

  def self.create_for(piece, game_state)
    return nil if game_state.nil? || !valid_initiator?(piece, game_state)

    actions = []

    partners = valid_partners(piece, game_state)

    partners.each do |partner|
      destination = initiator_destination(piece, partner)
      partner_destination = partner_destination(piece, partner)

      castling = new(piece, piece.position, destination, partner, partner_destination)

      actions << castling unless illegal_movement?(piece, partner, game_state)
    end

    actions
  end

  def self.valid_initiator?(initiator, game_state)
    return false unless initiator.respond_to?(:initiates_castling?) && initiator.initiates_castling?

    valid_initiator_position?(initiator.position) && !game_state.moved?(initiator)
  end

  def self.valid_initiator_position?(position)
    valid_positions = [
      Position.new('e1'),
      Position.new('e8')
    ]

    valid_positions.include?(position)
  end

  def self.valid_partner?(initiator, partner, game_state)
    return false unless partner.respond_to?(:castling_partner?) && partner.castling_partner?

    valid_partner_position?(initiator.position, partner.position) && !game_state.moved?(partner)
  end

  def self.valid_partner_position?(initiating_position, partner_position)
    if initiating_position == Position.new('e1')
      [Position.new('a1'), Position.new('h1')].include?(partner_position)
    elsif initiating_position == Position.new('e8')
      [Position.new('a8'), Position.new('h8')].include?(partner_position)
    else
      false
    end
  end

  def apply(_game_state)
    piece.position = move_to
    partner_piece.position = partner_move_to
  end

  def undo(_game_state)
    piece.position = move_from
    partner_piece.position = partner_move_from
  end

  def to_s
    "castling: #{@piece} from #{@move_from} to #{@move_to}, " \
      "#{@partner_piece} from #{@partner_move_from} to #{partner_move_to}"
  end

  def notation
    spaces_moved = (partner_move_from.file.ord - partner_move_to.file.ord).abs
    (['0'] * spaces_moved).join('-')
  end

  class << self
    private

    def initiator_destination(initiator, partner)
      x_direction = left_castle?(initiator, partner) ? -2 : 2
      offset = Offset.new([x_direction, 0])

      path_from_offset(initiator.position, offset)[0]
    end

    def partner_destination(initiator, partner)
      x_direction = left_castle?(initiator, partner) ? 3 : -2

      offset = Offset.new([x_direction, 0])
      path_from_offset(partner.position, offset)[0]
    end

    def left_castle?(piece, partner)
      piece.position.file > partner.position.file
    end

    def illegal_movement?(checkable_piece, partner, game_state)
      return true if path_blocked?(checkable_piece, partner, game_state)
      return true if path_attackable?(checkable_piece, partner, game_state)

      # return true if attackable_by_enemy_threat_map?(checkable_piece.owner, )

      false
    end

    def path_blocked?(initiator, partner, game_state)
      path = linear_path_from_positions(initiator.position, partner.position)

      positions_to_check = path[1...-1]
      positions_to_check.any? { |position| game_state.occupied_at?(position) }
    end

    def path_attackable?(initiator, partner, game_state)
      destination = initiator_destination(initiator, partner)
      path = linear_path_from_positions(initiator.position, destination)

      path.any? { |position| game_state.attackable_by_enemy?(initiator.owner, position) }
    end

    def valid_partners(initiator, game_state)
      return [] unless valid_initiator?(initiator, game_state)

      partners = []
      partners << game_state.select_position(Position.new("a#{initiator.position.rank}"))
      partners << game_state.select_position(Position.new("h#{initiator.position.rank}"))

      partners.compact.select { |partner| valid_partner?(initiator, partner, game_state) }
    end
  end
end
