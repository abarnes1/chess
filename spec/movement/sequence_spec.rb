require_relative '../../lib/movement/sequence'

describe Sequence do
  context '#positions' do
    context 'when offsets parameter is invalid' do
      it 'returns nil with when offsets parameter is nil' do
        nil_offsets = described_class.new(Position.new('c4'), nil)

        actual = nil_offsets.positions

        expect(actual).to be_nil
      end
    end

    context 'when offset contains no valid coordinate values' do
      it 'returns no positions sequence contains only nil' do
        nil_in_offset_sequence = described_class.new(Position.new('c4'), [nil])

        expected = []
        actual = nil_in_offset_sequence.positions

        expect(actual).to eq(expected)
      end

      it 'returns no positions when sequence is empty' do
        nil_in_offset_sequence = described_class.new(Position.new('c4'), [])

        expected = []
        actual = nil_in_offset_sequence.positions

        expect(actual).to eq(expected)
      end

      it 'returns no positions when sequence is out of range' do
        nil_in_offset_sequence = described_class.new(Position.new('c4'), [[777, 777]])

        expected = []
        actual = nil_in_offset_sequence.positions

        expect(actual).to eq(expected)
      end
    end

    context 'when a single point is used' do
      it 'calculates with positive offset' do
        positive_offset_sequence = described_class.new(Position.new('c4'), [[2, 2]])

        expected = [Position.new('e6')]
        actual = positive_offset_sequence.positions

        expect(actual).to eq(expected)
      end

      it 'calculates with negative offset' do
        negative_offset_sequence = described_class.new(Position.new('c4'), [[-2, -2]])

        expected = [Position.new('a2')]
        actual = negative_offset_sequence.positions

        expect(actual).to eq(expected)
      end
    end

    # context 'when a multiple points are used' do
    #   subject(:single_point) { described_class.new }
    # end
  end
end
