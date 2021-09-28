# frozen_string_literal: true

require_relative 'action'

# A basic chess move where one piece moves from
# its current square to another unoccupied square.
class Castling < Action
  attr_accessor :piece, :move_from, :move_to, :partner_piece, :partner_move_from, :partner_move_to

  def initialize(piece, move_from, move_to, partner_piece, partner_move_from, partner_move_to)
    super
    @piece = piece
    @move_to = move_to
    @move_from = move_from
    @partner_piece = partner_piece
    @partner_move_from = partner_move_from
    @partner_move_to = partner_move_to

    # puts "initializing #{self}"
  end

  def self.create_for(piece, game_state)
    return nil unless piece.can_castle?(game_state)

    puts 'inside Castling.create_for'
    partners = piece.castling_partners(game_state)

    moves = []

    partners.each do |partner|
      destination = calculate_single_sequence(piece.position, Offset.new([2, 0]))[0]
      distance = distance(piece, partner)
      partner_destination = calculate_single_sequence(partner.position, Offset.new([-distance, 0]))[0]

        if (left_castle?(piece, partner))
          destination = calculate_single_sequence(piece.position, Offset.new([-2, 0]))[0]
          partner_destination = calculate_single_sequence(partner.position, Offset.new([distance, 0]))[0]
        end

        castling = new(piece, piece.position, destination, partner, partner.position, partner_destination)

        moves << castling
    end

    puts moves
    moves
  end

  def apply(game_state)
    puts "applying castling: #{notation}"
    game_state.log_action(self)
    piece.position = move_to
    partner_piece.position = partner_move_to
  end

  def to_s
    "castling: #{@piece} from #{@move_from} to #{@move_to}, #{@partner_piece} from #{@partner_move_from} to #{partner_move_to}"
  end

  def notation
    # don't know why this doesn't work
    # spaces_moved = distance(piece, partner_piece)
    spaces_moved = (piece.position.file.ord - partner_piece.position.file.ord).abs - 1
    (['0'] * spaces_moved).join('-')
  end

  def self.left_castle?(piece, partner)
    # puts piece.position
    # puts partner.position
    # puts "#{piece.position.file > partner.position.file}"
    piece.position.file > partner.position.file
  end

  def self.distance(piece, partner)
    # puts "distance: #{(piece.position.file.ord - partner.position.file.ord).abs - 1}"
    (piece.position.file.ord - partner.position.file.ord).abs - 1
  end
end
