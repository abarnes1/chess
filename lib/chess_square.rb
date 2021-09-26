# frozen_string_literal: true

require_relative 'position'

# Object representation of a single square on a standard chessboard
class ChessSquare
  attr_accessor :color, :bg_color, :blink, :bg_highlight
  attr_reader :position

  def initialize(position, color_values = {})
    @position = position
    @piece = nil

    @bg_color = color_values.key?(:bg_color) ? color_values[:bg_color] : nil
    @bg_highlight = color_values.key?(:bg_highlight) ? color_values[:bg_highlight] : nil
    @piece = color_values.key?(:piece) ? "#{color_values[:piece]} " : '  '
    @color = color_values.key?(:color) ? color_values[:color] : nil
    @blink = color_values.key?(:blink) ? color_values[:blink] : false
  end

  def rank
    @position.rank
  end

  def file
    @position.file
  end

  def piece=(piece)
    @piece = piece.nil? ? '  ' : "#{piece} "
  end

  def clear_bg_highlight
    @bg_highlight = nil
  end

  def clear_piece
    self.piece = nil
  end

  def to_s
    output = @piece

    output = "\e[#{@bg_color}m#{@piece}\e[0m" if @bg_color # background color
    output = "\e[#{@bg_highlight}m#{@piece}\e[0m" if @bg_highlight # highlight color
    output = "\e[#{@color}m#{output}\e[0m" if @color # font color
    output = "\e[5m#{output}\e[25m" if @blink

    output
  end
end
