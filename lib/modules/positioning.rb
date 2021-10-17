# frozen_string_literal: true

require_relative '../position'
require_relative '../movement/offset'
require_relative '../movement/repeat_offset'

# Helper functions that are used to calculate moves and determine
# if they are inside the bounds of a normal chessboard.
module Positioning
  def next_position(position, offset)
    return nil if position.nil? || offset.nil?

    new_position = Position.new(calculate_file(position.file, offset.x) + calculate_rank(position.rank, offset.y))
    new_position.inbounds? ? new_position : nil
  end

  def path_group_from_offsets(position, offsets)
    return [] if offsets.nil?

    sequences = []

    offsets.each do |offset|
      sequence = path_from_offset(position, offset)
      sequences << sequence unless sequence.empty?
    end

    sequences
  end

  def path_from_offset(position, offset)
    return [] if offset.nil? || position.nil?

    sequence = []
    max_repeats = offset.is_a?(RepeatOffset) ? offset.max_repeats : 1
    current_position = position

    max_repeats.times do
      current_position = next_position(current_position, offset)

      break if current_position.nil? || !current_position.inbounds?

      sequence << current_position
    end

    sequence
  end

  def rank_difference(position_one, position_two)
    return nil if position_one.nil? || position_two.nil?

    position_two.rank.to_i - position_one.rank.to_i
  end

  def file_difference(position_one, position_two)
    return nil if position_one.nil? || position_two.nil?

    position_two.file.ord - position_one.file.ord
  end

  def linear_path?(starting, ending)
    return false if starting.nil? || ending.nil?
    return false if starting == ending

    sides = [file_difference(starting, ending), rank_difference(starting, ending)]

    return true if sides.one?(&:zero?)

    forms_isosceles_triangle?(sides)
  end

  def linear_path_from_positions(starting, ending)
    return nil unless linear_path?(starting, ending)

    next_position = starting
    path = [starting]

    until next_position == ending
      next_file = next_file(next_position.file, ending.file)
      next_rank = next_rank(next_position.rank, ending.rank)
      next_position = Position.new(next_file + next_rank)
      path << next_position
    end

    path
  end

  private

  def calculate_rank(rank, y_offset)
    (rank.to_i + y_offset).to_s
  end

  def forms_isosceles_triangle?(sides)
    return true if sides.uniq.size == 1 || sides.all? { |side| side.abs == 1 }

    hypotenuse = Math.sqrt(sides.map! { |side| side**2 }.sum)

    (hypotenuse % 1).zero?
  end

  def calculate_file(file, x_offset)
    new_file = file.ord + x_offset

    # Ruby valid character range 0-255
    return 255.chr unless new_file.between?(0, 255)

    new_file.chr
  end

  def next_rank(current, ending)
    case current.to_i <=> ending.to_i
    when -1
      (current.to_i + 1).to_s
    when 0
      current
    when 1
      (current.to_i - 1).to_s
    end
  end

  def next_file(current, ending)
    case current.ord <=> ending.ord
    when -1
      (current.ord + 1).chr
    when 0
      current
    when 1
      (current.ord - 1).chr
    end
  end
end
