require_relative '../lib/position_helpers'

class PositionHelperTestClass
  include PositionHelpers
end

describe PositionHelperTestClass do
  subject(:position_test) { described_class.new }

  describe '#inbounds?' do
    context 'when position is inbounds' do
      it "'a1' is inbounds" do
        position = Position.new('a1')
        expect(position_test.inbounds?(position)).to eq(true)
      end

      it "'h8' is inbounds" do
        position = Position.new('h8')
        expect(position_test.inbounds?(position)).to eq(true)
      end
    end

    context 'when position is not inbounds' do
      it "'a0' is not inbounds" do
        position = Position.new('a0')
        expect(position_test.inbounds?(position)).to eq(false)
      end

      it "'h9' is not inbounds" do
        position = Position.new('h9')
        expect(position_test.inbounds?(position)).to eq(false)
      end
    end

    context 'when position is not a Position object' do
      it 'returns nil for 1' do
        expect(position_test.inbounds?(1)).to be_nil
      end
    end

    context 'when position is not a string of length 2' do
      xit "returns nil for 'a1h'" do
        expect(position_test.inbounds?('a1h')).to be_nil
      end

      xit "returns nil for 'a'" do
        expect(position_test.inbounds?('a')).to be_nil
      end
    end
  end

  describe '#calculate_position' do
    subject(:calculate_test) { described_class.new }

    context 'when start is c4' do
      let(:start_position) { Position.new('c4') }

      it 'returns new position d5 after [ 1,  1] offset' do
        actual = calculate_test.calculate_position(start_position, [1, 1])
        expected = Position.new('d5')

        expect(actual).to eq(expected)
      end

      it 'returns new position b5 after [-1,  1] offset' do
        actual = calculate_test.calculate_position(start_position, [-1, 1])
        expected = Position.new('b5')

        expect(actual).to eq(expected)
      end

      it 'returns new position d3 after [ 1, -1] offset' do
        actual = calculate_test.calculate_position(start_position, [1, -1])
        expected = Position.new('d3')

        expect(actual).to eq(expected)
      end

      it 'returns new position b3 after [-1, -1] offset' do
        actual = calculate_test.calculate_position(start_position, [-1, -1])
        expected = Position.new('b3')

        expect(actual).to eq(expected)
      end

      it 'returns nil with [777, 0] offset' do
        actual = calculate_test.calculate_position(start_position, [777, 0])

        expect(actual).to be_nil
      end

      it 'returns nil with [0, 777] offset' do
        actual = calculate_test.calculate_position(start_position, [0, 777])

        expect(actual).to be_nil
      end
    end
  end
end
