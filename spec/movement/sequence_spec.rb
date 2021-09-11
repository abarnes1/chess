# frozen_string_literal: true

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
      it 'returns no positions when sequence contains only nil' do
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

    context 'when a multiple points are used' do
      it 'calculates all positions' do
        test_sequence = [[1, 1], [-2, -2], [3, 3]]
        multi_point_sequence = described_class.new(Position.new('c4'), test_sequence)

        expected = [
          Position.new('d5'),
          Position.new('b3'),
          Position.new('e6')
        ]
        actual = multi_point_sequence.positions

        expect(actual).to eq(expected)
      end

      context 'when sequence contains invalid value' do
        it 'stops the sequence on nil' do
          test_sequence = [[2, 2], nil, [2, 2]]
          sequence_with_nil = described_class.new(Position.new('c4'), test_sequence)

          expected = [Position.new('e6')]
          actual = sequence_with_nil.positions

          expect(actual).to eq(expected)
        end

        it 'stops the sequence on out of range' do
          test_sequence = [[2, 2], [777, 777], [1, 1]]
          sequence_with_out_of_range = described_class.new(Position.new('c4'), test_sequence)

          expected = [Position.new('e6')]
          actual = sequence_with_out_of_range.positions

          expect(actual).to eq(expected)
        end
      end
    end
  end
end
