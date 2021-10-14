require_relative '../../lib/modules/positioning'

class PositioningModuleTestClass
  include Positioning
end

describe PositioningModuleTestClass do
  subject(:positioning) { described_class.new }

  describe '#linear_path?' do
    context 'when starting position is nil' do
      it 'returns false' do
        starting = nil
        ending = Position.new('a1')
        expect(positioning.linear_path?(starting, ending)).to be false
      end
    end

    context 'when ending position is nil' do
      it 'returns false' do
        starting = Position.new('a1')
        ending = nil
        expect(positioning.linear_path?(starting, ending)).to be false
      end
    end

    context 'when positions are linear' do
      context 'when positions are horizontal line' do
        it 'returns true for a4 to d4' do
          starting = Position.new('a4')
          ending = Position.new('d4')
          expect(positioning.linear_path?(starting, ending)).to be true
        end
  
        it 'returns true for h8 to h1' do
          starting = Position.new('h8')
          ending = Position.new('h1')
          expect(positioning.linear_path?(starting, ending)).to be true
        end
      end
  
      context 'when positions are vertical line' do
        it 'returns true for a1 to a4' do
          starting = Position.new('a1')
          ending = Position.new('a4')
          expect(positioning.linear_path?(starting, ending)).to be true
        end
  
        it 'returns true for h8 to h1' do
          starting = Position.new('h8')
          ending = Position.new('h1')
          expect(positioning.linear_path?(starting, ending)).to be true
        end
      end
  
      context 'when positions are diagonal' do
        it 'returns true for a1 to h8' do
          starting = Position.new('a1')
          ending = Position.new('h8')
          expect(positioning.linear_path?(starting, ending)).to be true
        end
  
        it 'returns true for d8 to a5' do
          starting = Position.new('d8')
          ending = Position.new('a5')
          expect(positioning.linear_path?(starting, ending)).to be true
        end
      end
    end

    context 'when positions are not linear' do
      it 'returns false for a1 to b3' do
        starting = Position.new('a1')
        ending = Position.new('b3')
        expect(positioning.linear_path?(starting, ending)).to be false
      end

      it 'returns false for b2 to e8' do
        starting = Position.new('b2')
        ending = Position.new('e8')
        expect(positioning.linear_path?(starting, ending)).to be false
      end
    end

    context 'when positions are the same' do
      it 'returns false for a1 to a1' do
        starting = Position.new('a1')
        ending = Position.new('a1')

        expect(positioning.linear_path?(starting, ending)).to be false
      end
    end
  end

  describe '#linear_path_from_positions' do
    context 'when path is not linear' do
      it 'returns nil for a1 to b4' do
        starting = Position.new('a1')
        ending = Position.new('b4')

        expect(positioning.linear_path_from_positions(starting, ending)).to be_nil
      end
    end

    context 'when path is horizontal' do
      it 'returns the path for a1 to b1' do
        starting = Position.new('a1')
        ending = Position.new('b1')
        expected = [Position.new('a1'), Position.new('b1')]
        actual = positioning.linear_path_from_positions(starting, ending)

        expect(actual).to eq(expected)
      end

      it 'returns the path for f2 to c2' do
        starting = Position.new('f2')
        ending = Position.new('c2')
        expected = [Position.new('f2'), Position.new('e2'), Position.new('d2'), Position.new('c2')]
        actual = positioning.linear_path_from_positions(starting, ending)

        expect(actual).to eq(expected)
      end
    end

    context 'when path is vertical' do
      it 'returns the path for a1 to a2' do
        starting = Position.new('a1')
        ending = Position.new('a2')
        expected = [Position.new('a1'), Position.new('a2')]
        actual = positioning.linear_path_from_positions(starting, ending)

        expect(actual).to eq(expected)
      end

      it 'returns the path for h3 to h1' do
        starting = Position.new('h3')
        ending = Position.new('h1')
        expected = [Position.new('h3'), Position.new('h2'), Position.new('h1')]
        actual = positioning.linear_path_from_positions(starting, ending)

        expect(actual).to eq(expected)
      end
    end

    context 'when path is diagonal' do
      it 'returns the path for a1 to b2' do
        starting = Position.new('a1')
        ending = Position.new('b2')
        expected = [Position.new('a1'), Position.new('b2')]
        actual = positioning.linear_path_from_positions(starting, ending)

        expect(actual).to eq(expected)
      end

      it 'returns the path for e8 to c6' do
        starting = Position.new('e8')
        ending = Position.new('c6')
        expected = [Position.new('e8'), Position.new('d7'), Position.new('c6')]
        actual = positioning.linear_path_from_positions(starting, ending)

        expect(actual).to eq(expected)
      end
    end
  end

  describe '#next_position' do
    context 'when position parameter is invalid' do
      let(:valid_offset) { Offset.new([1, 1]) }

      it 'returns nil when position nil' do
        actual = positioning.next_position(nil, valid_offset)
        expect(actual).to be_nil
      end

      it 'returns nil when position out of bounds' do
        out_of_bounds_position = Position.new('z9')
        actual = positioning.next_position(out_of_bounds_position, valid_offset)
        expect(actual).to be_nil
      end
    end

    context 'when offset parameter is invalid' do
      let(:valid_position) { Position.new('c4') }

      it 'returns nil when offset nil' do
        actual = positioning.next_position(valid_position, nil)
        expect(actual).to be_nil
      end

      it 'returns nil when offset out of bounds' do
        out_of_bounds_offset = Offset.new([777, 777])
        actual = positioning.next_position(valid_position, out_of_bounds_offset)
        expect(actual).to be_nil
      end
    end

    context 'when offset is positive' do
      let(:start_position) { Position.new('c4')}

      it 'calculates the correct position' do
        positive_offset = Offset.new([3, 3])
        expected = Position.new('f7')
        actual = positioning.next_position(start_position, positive_offset)

        expect(actual).to eq(expected)
      end
    end

    context 'when offset is negative' do
      let(:start_position) { Position.new('c4')}

      it 'calculates the correct position' do
        negative_offset = Offset.new([-2, -2])
        expected = Position.new('a2')
        actual = positioning.next_position(start_position, negative_offset)

        expect(actual).to eq(expected)
      end
    end
  end

  describe '#path_from_offset' do
    let(:start_position) { Position.new('c4') }

    context 'when parameter position is invalid' do
      let(:valid_offset) { Offset.new([1, 1]) }

      it 'returns empty array when position is nil' do
        actual = positioning.path_from_offset(nil, valid_offset)
        expect(actual).to eq([])
      end

      it 'returns empty array when position out of range' do
        out_of_range_position = Position.new('z9')

        actual = positioning.path_from_offset(out_of_range_position, valid_offset)
        expect(actual).to eq([])
      end
    end

    context 'when parameter offset is invalid' do
      let(:out_of_range_offset) { Offset.new([777, 777]) }
      
      it 'returns empty array when offset is nil' do
        actual = positioning.path_from_offset(start_position, nil)
        expect(actual).to eq([])
      end

      it 'returns empty array when no valid positions can be calculated' do
        actual = positioning.path_from_offset(start_position, out_of_range_offset)
        expect(actual).to eq([])
      end
    end

    context 'when offset is not repeating' do
      let(:single_offset) { Offset.new([1, 1]) }

      it 'returns a single valid position' do
        expected = [ Position.new('d5') ]

        actual = positioning.path_from_offset(start_position, single_offset)
  
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
  
        actual = positioning.path_from_offset(start_position, repeating_offset)
  
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
  
        actual = positioning.path_from_offset(start_position, repeating_offset)
  
        expect(actual).to eq(expected)
      end
    end
  end

  describe '#path_group_from_offsets' do
    let(:start_position) { Position.new('c4') }

    it 'contains no empty sequences' do
      offsets = [
        RepeatOffset.new([2, 2], 2),
        Offset.new([777, 777])
      ]

      expected = [
        [Position.new('e6'), Position.new('g8')]
      ]

      actual = positioning.path_group_from_offsets(start_position, offsets)
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

      actual = positioning.path_group_from_offsets(start_position, offsets)
      expect(actual).to eq(expected)
    end
  end

  describe '#file_difference' do
    context 'when parameter is invalid' do
      it 'returns nil when first parameter is nil' do
        position_one = Position.new('a2')
        position_two = nil

        actual = positioning.file_difference(position_one, position_two)
        expect(actual).to be_nil
      end

      it 'returns nil when second parameter is nil' do
        position_one = nil
        position_two = Position.new('a2')

        actual = positioning.file_difference(position_one, position_two)
        expect(actual).to be_nil
      end
    end

    context 'when left to right (a1 -> h1)' do
      it 'returns correct distance' do
        position_one = Position.new('a1')
        position_two = Position.new('h1')

        actual = positioning.file_difference(position_one, position_two)
        expect(actual).to eq(7)
      end
    end

    context 'when right to left (h4 -> b1)' do
      it 'returns correct distance' do
        position_one = Position.new('h4')
        position_two = Position.new('b1')

        actual = positioning.file_difference(position_one, position_two)
        expect(actual).to eq(-6)
      end
    end
  end 

  describe '#rank_difference' do
    context 'when parameter is invalid' do
      it 'returns nil when first parameter is nil' do
        position_one = Position.new('a2')
        position_two = nil

        actual = positioning.rank_difference(position_one, position_two)
        expect(actual).to be_nil
      end

      it 'returns nil when second parameter is nil' do
        position_one = nil
        position_two = Position.new('a2')

        actual = positioning.rank_difference(position_one, position_two)
        expect(actual).to be_nil
      end
    end

    context 'when top to bottom (b8 -> b2)' do
      it 'returns correct distance' do
        position_one = Position.new('b8')
        position_two = Position.new('b2')

        actual = positioning.rank_difference(position_one, position_two)
        expect(actual).to eq(-6)
      end
    end

    context 'when bottom to top (a1 -> c5)' do
      it 'returns correct distance' do
        position_one = Position.new('a1')
        position_two = Position.new('c5')

        actual = positioning.rank_difference(position_one, position_two)
        expect(actual).to eq(4)
      end
    end
  end
end
