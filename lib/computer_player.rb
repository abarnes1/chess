# frozen_string_literal: true

# Contains attributes for a computer player that can take a random action.
class ComputerPlayer
  attr_reader :name, :color

  def initialize(label, color)
    @name = "Cpu (#{label})"
    @color = color
  end

  def choose_action(actions)
    return nil if actions.nil?

    actions.sample
  end
end