# frozen_string_literal: true

require_relative 'chess_square'
require_relative 'constants/colors'

# Visual representation of a classic chessboard.
class Chessboard
  attr_reader :primary_background_color, :secondary_background_color

  def initialize
    @squares = nil
    @primary_background_color = Colors::BG_BLACK
    @secondary_background_color = Colors::BG_BRIGHT_GRAY
  end

  def squares
    initialize_squares if @squares.nil?

    @squares
  end

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

  def display
    output = ''
    ranks = ('1'..'8').to_a.reverse

    ranks.each_with_index do |rank, index|
      output += "#{(index - 8).abs} "
      row = squares.select { |square| square.rank == rank }

      row.each { |item| output += item.to_s }
      output += "\n"
    end

    output += "  a b c d e f g h\n"
  end

  def select(position)
    squares.find { |square| square.position == position }
  end

  def display_pieces(pieces)
    pieces.each do |piece|
      square = select(piece.position)
      square.piece = piece
      square.color = piece_color(piece.owner)
    end
  end

  def highlight_actions(actions)
    return if actions.nil? || actions.empty?

    actions.each do |action|
      destination = select(action.move_to)

      destination.bg_highlight = action_background_color(action)
    end
  end

  def highlight_threat_map(threat_map)
    threat_map.each do |position|
      square = select(position)
      square.bg_highlight = Colors::BG_BRIGHT_BROWN
    end
  end

  def reset_squares
    squares.each do |square|
      square.clear_piece
      square.clear_bg_highlight
    end
  end

  private

  def piece_color(owner)
    if owner.respond_to?(:color)
      owner.color
    elsif owner.respond_to?(:has_key?)
      owner[:color]
    else
      Colors::CYAN
    end
  end

  def initialize_squares
    @squares = Array.new(64)
    ranks = ('1'..'8').to_a
    files = ('a'..'h').to_a
    positions = files.product(ranks).map(&:join)

    @squares.each_index do |index|
      position = Position.new(positions[index])
      colors = { bg_color: default_background_color(position) }

      square = ChessSquare.new(position, colors)
      squares[index] = square
    end
  end

  def default_background_color(position)
    position_value = (position.file.ord + position.rank.to_i) % 2
    position_value.zero? ? @primary_background_color : @secondary_background_color
  end

  def update_square_default_background(old_color, new_color)
    to_update = squares.select { |square| square.bg_color == old_color }
    to_update.each { |square| square.bg_color = new_color }
  end

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
end
