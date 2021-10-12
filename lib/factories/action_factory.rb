# frozen_string_literal: true

Dir['lib/actions/*.rb'].sort.each { |file| require_relative "../../#{file}" }

# Creates all actions of Action class children types given a Chesspiece
# and GameState object.
class ActionFactory
  def initialize; end

  def self.actions_for(piece, game_state)
    moves = []

    Action.registered_children.each do |action_type|
      moves << action_type.create_for(piece, game_state)
    end

    moves.flatten.compact
  end
end
