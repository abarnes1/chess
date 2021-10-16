require_relative 'modules/positioning'
require_relative 'game_state'

# Represents all attackable squares that the opposing player
# can attack on their next turn.  Used to prevent the current
# player from moving its king to an attackable position.
class ThreatMap
  include Positioning

  def initialize(pieces)
    @pieces = pieces
  end

  # needs a reference to pieces and
  # a way to find the enemy pieces
  def referenced_pieces(pieces)
    @referenced_pieces = pieces
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

        threat_map << position

        covered = true if @pieces.any? { |piece| piece.position == position }
      end
    end

    threat_map
  end
end
