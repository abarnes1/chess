require_relative '../../lib/modules/positioning'

class PositioningTestClass
  include Positioning
end

describe PositioningTestClass do
  context '#next_position' do
    subject(:position_tester) { described_class.new }

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
end