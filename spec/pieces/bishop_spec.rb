# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative 'shared/default_castling'
require_relative 'shared/default_check'
require_relative 'shared/default_en_passant'

describe Bishop do
  subject(:default_bishop) { described_class.new(position: Position.new('c4')) }

  context '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1])
      ]

      actual = default_bishop.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  context '#movement_offsets' do
    it 'has the correct movement offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1])
      ]

      actual = default_bishop.move_offsets

      expect(actual).to eq(expected)
    end
  end

    # Bishop has no special behaviors
    context "when #{described_class.name} implements default behaviors" do
      include_examples 'default castling behavior'
      include_examples 'default check behavior'
      include_examples 'default en passant behavior'
    end
end
