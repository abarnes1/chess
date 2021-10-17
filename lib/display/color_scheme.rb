# frozen_string_literal: true

# Determines highlight color for Action classes.
module ColorScheme
  attr_reader :primary_background_color, :secondary_background_color

  def primary_background_color=(color)
    return if color == @secondary_background_color

    update_square_default_background(@primary_background_color, color)
    @primary_background_color = color
  end

  def secondary_background_color=(color)
    return if color == @primary_background_color

    update_square_default_background(@secondary_background_color, color)
    @secondary_background_color = color
  end

  def default_primary_background_color
    Colors::BG_BLACK
  end

  def default_secondary_background_color
    Colors::BG_BRIGHT_GRAY
  end

  # rubocop: disable Metrics/MethodLength
  def action_background_color(action)
    case action
    when Move
      Colors::BG_CYAN
    when Capture
      Colors::BG_RED
    when Promote
      Colors::BG_BRIGHT_GREEN
    when PromoteCapture
      Colors::BG_MAGENTA
    when EnPassant
      Colors::BG_RED
    when Castling
      Colors::BG_GREEN
    end
  end
  # rubocop: enable Metrics/MethodLength
end
