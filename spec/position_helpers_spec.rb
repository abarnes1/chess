require_relative '../lib/position_helpers'

class PositionHelperTestClass
  include PositionHelpers
end

describe PositionHelperTestClass do
  subject(:position_test) { described_class.new }

  describe '#inbounds?' do
    context 'when position is inbounds' do
      it "'a1' is inbounds" do
        expect(position_test.inbounds?('a1')).to eq(true)
      end

      it "'h8' is inbounds" do
        expect(position_test.inbounds?('h8')).to eq(true)
      end
    end

    context 'when position is not inbounds' do
      it "'a0' is not inbounds" do
        expect(position_test.inbounds?('a0')).to eq(false)
      end
sa
      it "'h9' is not inbounds" do
        expect(position_test.inbounds?('h9')).to eq(false)
      end
    end

    context 'when position is not a string' do
      it 'returns nil for 1' do
        expect(position_test.inbounds?(1)).to be_nil
      end
    end

    context 'when position is not a string of length 2' do
      it "returns nil for 'a1h'" do
        expect(position_test.inbounds?('a1h')).to be_nil
      end

      it "returns nil for 'a'" do
        expect(position_test.inbounds?('a')).to be_nil
      end
    end
  end

  describe '#calculate_position' do
    subject(:calculate_test) { described_class.new }

    context 'when position c4 with [1, 1] offset' do
      it 'returns new position d5' do
        actual = calculate_test.calculate_position('c4', [1, 1])
        expected = 'd5'

        expect(actual).to eq(expected)
      end
    end

    context 'when position c4 with [-1, -1] offset' do
      it 'returns new position b3' do
        actual = calculate_test.calculate_position('c4', [-1, -1])
        expected = 'b3'

        expect(actual).to eq(expected)
      end
    end

    context 'when position c4 with [777, 0] offset' do
      it 'returns nil' do
        actual = calculate_test.calculate_position('c4', [777, 0])

        expect(actual).to be_nil
      end
    end

    context 'when position c4 with [0, 777] offset' do
      it 'returns nil' do
        actual = calculate_test.calculate_position('c4', [0, 777])

        expect(actual).to be_nil
      end
    end
  end
end
