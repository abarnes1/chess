# frozen_string_literal: true

require_relative '../../lib/pieces/queen'
require_relative 'shared/default_castling'
require_relative 'shared/default_check'
require_relative 'shared/default_en_passant'

describe Queen do
  subject(:default_queen) { described_class.new(position: Position.new('c4')) }

  context '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1]),
        RepeatOffset.new([1, 0]),
        RepeatOffset.new([-1, 0]),
        RepeatOffset.new([0, 1]),
        RepeatOffset.new([0, -1])
      ]

      actual = default_queen.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  context '#movement_offsets' do
    it 'has the correct movement offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1]),
        RepeatOffset.new([1, 0]),
        RepeatOffset.new([-1, 0]),
        RepeatOffset.new([0, 1]),
        RepeatOffset.new([0, -1])
      ]

      actual = default_queen.move_offsets

      expect(actual).to eq(expected)
    end
  end

  # Queen has no special behaviors
  context "when #{described_class.name} implements default behaviors" do
    include_examples 'default castling behavior'
    include_examples 'default check behavior'
    include_examples 'default en passant behavior'
  end
end
