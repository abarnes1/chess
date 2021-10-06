# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative '../../lib/game_state'

describe Bishop do
  subject(:default_bishop) { described_class.new(position: Position.new('c4')) }

  context '#can_be_checked?' do
    it 'cannot be put in check' do
      actual = default_bishop.can_be_checked?
      expect(actual).to be false
    end
  end

  context '#can_promote_at?' do
    it 'cannot promote at rank 1' do
      actual = default_bishop.can_promote_at?(Position.new('a1')) && default_bishop.can_promote_at?(Position.new('a1'))
      expect(actual).to be false
    end

    it 'cannot promote at rank 8' do
      actual = default_bishop.can_promote_at?(Position.new('a8')) && default_bishop.can_promote_at?(Position.new('a1'))
      expect(actual).to be false
    end
  end

  context '#capture_offsets' do
    it 'has the correct capture offsets set' do
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

  context '#castling_partner?' do
    it 'cannot be a castling partner' do
      actual = default_bishop.castling_partner?
      expect(actual).to be false
    end
  end

  context '#movement_offsets' do
    it 'has the correct movement offsets set' do
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

  # Bishop will always return false
  context '#can_en_passant?' do
    it 'cannot en passant' do
      expect(default_bishop).to receive(:can_en_passant?).and_call_original

      actual = default_bishop.can_en_passant?(nil)
      expect(actual).to be false
    end
  end

  # Bishop will always return false
  context '#can_castle?' do
    it 'cannot castle with given game state' do
      actual = default_bishop.can_castle?(nil)
      expect(actual).to be false
    end
  end

  # Bishop will always return false
  context '#valid_castling_partners?' do
    it 'has no castling partners' do
      actual = default_bishop.valid_castling_partners(nil)
      expect(actual).to be_nil
    end
  end
end
