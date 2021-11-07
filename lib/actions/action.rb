# frozen_string_literal: true

require_relative '../modules/positioning'

# Parent class that provides necessary shared behavior and
# interface methods that child Action types (Move, Capture, etc..)
# should override.
class Action
  extend Positioning

  attr_reader :move_from, :move_to, :piece

  def initialize(*_args) end

  def self.register_child(child)
    registered_children.prepend(child)
  end

  def self.registered_children
    @registered_children ||= []
  end

  def self.inherited(subclass)
    super
    register_child(subclass)
  end

  def self.create_for
    raise NotImplementedError
  end

  def apply(game_state)
    raise NotImplementedError
  end

  def undo(game_state)
    raise NotImplementedError
  end

  def notation
    raise NotImplementedError
  end

  def to_s
    raise NotImplementedError
  end
end
