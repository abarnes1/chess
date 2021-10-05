require_relative '../../lib/movement/offset'

describe Offset do
  context '#initialize' do
    let(:x) { 0 }
    let(:y) { 1 }
    subject(:new_offset) { described_class.new([x, y])}

    it 'sets the x value with first array element' do
      actual = new_offset.x
      expect(actual).to eq(x)
    end

    it 'sets the y value with second array element' do
      actual = new_offset.y
      expect(actual).to eq(y)
    end
  end

  context '#==' do
    let(:x) { 0 }
    let(:y) { 1 }
    subject(:first_offset) { described_class.new([x, y])}
    let(:second_offset) { double(Offset) }

    it 'is not equal when x does not match' do
      allow(second_offset).to receive(:x).and_return(x + 1)
      allow(second_offset).to receive(:y).and_return(y)

      actual = (first_offset == second_offset)
      expect(actual).to be false
    end

    it 'is not equal when y does not match' do
      allow(second_offset).to receive(:x).and_return(x)
      allow(second_offset).to receive(:y).and_return(y + 1)

      actual = (first_offset == second_offset)
      expect(actual).to be false
    end

    it 'is not equal compared to nil' do
      actual = (first_offset == nil)
      expect(actual).to be false
    end

    it 'is equal when x and y match' do
      allow(second_offset).to receive(:x).and_return(x)
      allow(second_offset).to receive(:y).and_return(y)

      actual = (first_offset == second_offset)
      expect(actual).to be true
    end
  end
end