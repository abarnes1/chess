require_relative '../modules/positioning'

class ActionCalculator
  extend Positioning

  def initialize; end

  def self.actions_for(piece, game_info = nil)
    actions = []

    if game_info.nil?
      actions << default_moves(piece, game_info)
    end
  end

  private

  def self.default_moves(piece, _game_info)
    moves = []

    piece.offsets.each do |offset|
      current_position = piece.position
      until current_position.nil?
        current_position = next_position(current_position, offset)

        unless current_position.nil? || current_position == piece.position
          moves << ActionFactory.create_action(Move, piece, piece.position, current_position)
        end

        break unless offset.is_a? RepeatOffset
      end
    end
  end
end