# frozen_string_literal: true

require_relative 'chess_square'
require_relative '../constants/colors'
require_relative 'color_scheme'

# Visual representation of a classic chessboard.
class Chessboard
  include ColorScheme

  def initialize
    @squares = nil
  end

  def squares
    initialize_squares if @squares.nil?

    @squares
  end

  def colorable_items
    squares
  end

  def display
    displayable_rows.join("\n")
  end

  def displayable_rows
    output = []
    ranks = ('1'..'8').to_a.reverse

    ranks.each_with_index do |rank, index|
      new_line = "#{(index - 8).abs} "
      row = squares.select { |square| square.rank == rank }

      row.each { |item| new_line += item.to_s }
      output << new_line
    end

    output << '  a b c d e f g h'
  end

  def select(position)
    squares.find { |square| square.position == position }
  end

  def update(pieces)
    reset_squares
    display_pieces(pieces)
  end

  def display_pieces(pieces)
    reset_squares

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

  def clear_highlights
    squares.each(&:clear_bg_highlight)
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
    position_value.zero? ? default_primary_background_color : default_secondary_background_color
  end
end
