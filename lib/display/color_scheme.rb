# frozen_string_literal: true

# Determines colors to display on a Chessboard.
module ColorScheme
  attr_reader :primary_background_color, :secondary_background_color, :colorable_items

  def primary_background_color=(color)
    old_color = primary_background_color
    @primary_background_color = color

    update_square_default_background(old_color, primary_background_color)
  end

  def secondary_background_color=(color)
    old_color = secondary_background_color
    @secondary_background_color = color

    update_square_default_background(old_color, secondary_background_color)
  end

  def default_primary_background_color
    Colors::BG_MAGENTA
  end

  def default_secondary_background_color
    Colors::BG_BLUE
  end

  def randomize_background_colors
    self.primary_background_color = Colors.random_background([primary_background_color, secondary_background_color])
    self.secondary_background_color = Colors.random_background([primary_background_color, secondary_background_color])
  end

  def reset_color_scheme
    self.primary_background_color = default_primary_background_color
    self.secondary_background_color = default_secondary_background_color
  end

  def update_square_default_background(old_color, new_color)
    to_update = colorable_items.select { |item| item.bg_color == old_color }
    to_update.each { |item| item.bg_color = new_color }
  end

  # rubocop: disable Metrics/MethodLength
  def action_background_color(action)
    case action
    when Move
      Colors::BG_CYAN
    when Capture
      Colors::BG_RED
    when Promote
      Colors::BG_GREEN
    when PromoteCapture
      Colors::BG_RED
    when EnPassant
      Colors::BG_RED
    when Castling
      Colors::BG_GREEN
    end
  end
  # rubocop: enable Metrics/MethodLength
end
