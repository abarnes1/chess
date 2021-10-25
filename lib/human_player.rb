# frozen_string_literal: true

# Contains attributes for a human player
class HumanPlayer
  attr_reader :name, :color

  def initialize(label, color)
    @name = "Human (#{label})"
    @color = color
  end
end
