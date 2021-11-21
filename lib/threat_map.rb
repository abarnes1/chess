# frozen_string_literal: true

require_relative 'modules/positioning'

# Represents all attackable squares that a player can attack on their next
# turn. Used to detect landing spots where the enemy king can't land because
# it would put itself in check.  Includes all empty attackable squares and
# squares that are attackable by at least one piece in the event of a capture.
class ThreatMap
  include Positioning

  def initialize(pieces)
    @all_pieces = pieces
  end

  def calculate(pieces)
    paths = all_possible_attacks(pieces)
    threat_map = covered_positions(paths)

    threat_map.uniq
  end

  private

  def all_possible_attacks(pieces)
    paths = []

    pieces.each do |piece|
      paths += path_group_from_offsets(piece.position, piece.capture_offsets)
    end

    paths
  end

  def covered_positions(paths)
    threat_map = []

    paths.each do |path|
      covered = false

      path.each do |position|
        break if covered

        threat_map << position unless already_threatened?(threat_map, position)

        covered = true if @all_pieces.any? { |piece| piece.position == position }
      end
    end

    threat_map
  end

  def already_threatened?(threatened_position, position)
    threatened_position.any? { |pos| pos == position }
  end
end
