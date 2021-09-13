require_relative '../../lib/modules/positioning'

class PositioningModuleTestClass
  include Positioning
end

describe PositioningModuleTestClass do
  subject(:position_tester) { described_class.new }

  context '#next_position' do
    context 'when position parameter is invalid' do
      let(:valid_offset) { Offset.new([1, 1]) }

      it 'returns nil when nil' do
        actual = position_tester.next_position(nil, valid_offset)
        expect(actual).to be_nil
      end

      it 'returns nil when out of bounds' do
        out_of_bounds_position = Position.new('z9')
        actual = position_tester.next_position(out_of_bounds_position, valid_offset)
        expect(actual).to be_nil
      end
    end

    context 'when offset parameter is invalid' do
      let(:valid_position) { Position.new('c4') }

      it 'returns nil when nil' do
        actual = position_tester.next_position(valid_position, nil)
        expect(actual).to be_nil
      end

      it 'returns nil when out of bounds' do
        out_of_bounds_offset = Offset.new([777, 777])
        actual = position_tester.next_position(valid_position, out_of_bounds_offset)
        expect(actual).to be_nil
      end

      context 'when offset is positive' do
        let(:start_position) { Position.new('c4')}

        it 'calculates the correct position' do
          positive_offset = Offset.new([3, 3])
          expected = Position.new('f7')
          actual = position_tester.next_position(start_position, positive_offset)

          expect(actual).to eq(expected)
        end
      end

      context 'when offset is negative' do
        let(:start_position) { Position.new('c4')}

        it 'calculates the correct position' do
          negative_offset = Offset.new([-2, -2])
          expected = Position.new('a2')
          actual = position_tester.next_position(start_position, negative_offset)

          expect(actual).to eq(expected)
        end
      end
    end
  end

  context '#position_chain' do
    # figure out behavior when offset nil
    let(:start_position) { Position.new('c4') }
    let(:repeating_offset) { Offset.new([1, 1], repeat: true)}

    it 'returns empty array when offset is nil' do
      actual = position_tester.position_chain(start_position, nil)
      expect(actual).to eq([])
    end

    it 'returns empty array when position is nil' do
      actual = position_tester.position_chain(nil, repeating_offset)
      expect(actual).to eq([])
    end

    it 'returns one item when offset does not repeat' do
      not_repeating_offset = Offset.new([1, 1])
      expected = [Position.new('d5')]

      actual = position_tester.position_chain(start_position, not_repeating_offset)
      expect(actual).to eq(expected)
    end

    it 'returns all valid positions in order' do
      expected = [
        Position.new('d5'),
        Position.new('e6'),
        Position.new('f7'),
        Position.new('g8')
      ]

      actual = position_tester.position_chain(start_position, repeating_offset)

      expect(actual).to eq(expected)
    end
  end

  context '#position_sequences' do
    let(:start_position) { Position.new('c4') }

    it 'contains no empty sequences' do
      offsets = [
        Offset.new([2, 2], repeat: true),
        Offset.new([777, 777])
      ]

      expected = [
        [Position.new('e6'), Position.new('g8')]
      ]

      actual = position_tester.position_sequences(start_position, offsets)
      expect(actual).to eq(expected)
    end

    it 'calculates multiple sequences' do
      offsets = [
        Offset.new([2, 2], repeat: true),
        Offset.new([777, 777]),
        Offset.new([3, 3], repeat: true),
        Offset.new([1, 1])
      ]

      expected = [
        [Position.new('e6'), Position.new('g8')],
        [Position.new('f7')],
        [Position.new('d5')]
      ]

      actual = position_tester.position_sequences(start_position, offsets)
      expect(actual).to eq(expected)
    end
  end
end