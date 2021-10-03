require_relative '../../lib/modules/positioning'

class PositioningModuleTestClass
  include Positioning
end

describe PositioningModuleTestClass do
  subject(:position_tester) { described_class.new }

  context '#next_position' do
    context 'when position parameter is invalid' do
      let(:valid_offset) { Offset.new([1, 1]) }

      it 'returns nil when position nil' do
        actual = position_tester.next_position(nil, valid_offset)
        expect(actual).to be_nil
      end

      it 'returns nil when position out of bounds' do
        out_of_bounds_position = Position.new('z9')
        actual = position_tester.next_position(out_of_bounds_position, valid_offset)
        expect(actual).to be_nil
      end
    end

    context 'when offset parameter is invalid' do
      let(:valid_position) { Position.new('c4') }

      it 'returns nil when offset nil' do
        actual = position_tester.next_position(valid_position, nil)
        expect(actual).to be_nil
      end

      it 'returns nil when offset out of bounds' do
        out_of_bounds_offset = Offset.new([777, 777])
        actual = position_tester.next_position(valid_position, out_of_bounds_offset)
        expect(actual).to be_nil
      end
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

  context '#calculate_sequence' do
    let(:start_position) { Position.new('c4') }

    context 'when parameter position is invalid' do
      let(:valid_offset) { Offset.new([1, 1]) }

      it 'returns empty array when position is nil' do
        actual = position_tester.calculate_sequence(nil, valid_offset)
        expect(actual).to eq([])
      end

      it 'returns empty array when position out of range' do
        out_of_range_position = Position.new('z9')

        actual = position_tester.calculate_sequence(out_of_range_position, valid_offset)
        expect(actual).to eq([])
      end
    end

    context 'when parameter offset is invalid' do
      let(:out_of_range_offset) { Offset.new([777, 777]) }
      
      it 'returns empty array when offset is nil' do
        actual = position_tester.calculate_sequence(start_position, nil)
        expect(actual).to eq([])
      end

      it 'returns empty array when no valid positions can be calculated' do
        actual = position_tester.calculate_sequence(start_position, out_of_range_offset)
        expect(actual).to eq([])
      end
    end

    context 'when offset is not repeating' do
      let(:single_offset) { Offset.new([1, 1]) }

      it 'returns a single valid position' do
        expected = [ Position.new('d5') ]

        actual = position_tester.calculate_sequence(start_position, single_offset)
  
        expect(actual).to eq(expected)
      end
    end

    context 'when offset repeats twice' do
      let(:repeating_offset) { RepeatOffset.new([1, 1], 2) }

      it 'returns all valid positions' do
        expected = [
          Position.new('d5'),
          Position.new('e6'),
        ]
  
        actual = position_tester.calculate_sequence(start_position, repeating_offset)
  
        expect(actual).to eq(expected)
      end
    end

    context 'when offset repeats until out of bounds' do
      let(:repeating_offset) { RepeatOffset.new([1, 1], 777) }

      it 'returns all valid positions' do
        expected = [
          Position.new('d5'),
          Position.new('e6'),
          Position.new('f7'),
          Position.new('g8')
        ]
  
        actual = position_tester.calculate_sequence(start_position, repeating_offset)
  
        expect(actual).to eq(expected)
      end
    end
  end

  context '#calculate_sequence_set' do
    let(:start_position) { Position.new('c4') }

    it 'contains no empty sequences' do
      offsets = [
        RepeatOffset.new([2, 2], 2),
        Offset.new([777, 777])
      ]

      expected = [
        [Position.new('e6'), Position.new('g8')]
      ]

      actual = position_tester.calculate_sequence_set(start_position, offsets)
      expect(actual).to eq(expected)
    end

    it 'calculates multiple sequences' do
      offsets = [
        RepeatOffset.new([2, 2]),
        Offset.new([777, 777]),
        RepeatOffset.new([3, 3]),
        Offset.new([1, 1])
      ]

      expected = [
        [Position.new('e6'), Position.new('g8')],
        [Position.new('f7')],
        [Position.new('d5')]
      ]

      actual = position_tester.calculate_sequence_set(start_position, offsets)
      expect(actual).to eq(expected)
    end
  end
end