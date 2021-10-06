require_relative '../../lib/movement/offset'

describe Offset do
  context '#initialize' do
    x_coord = 0
    y_coord = 1
    subject(:new_offset) { described_class.new([x_coord, y_coord])}

    it 'sets the x value with first array element' do
      actual = new_offset.x
      expect(actual).to eq(x_coord)
    end

    it 'sets the y value with second array element' do
      actual = new_offset.y
      expect(actual).to eq(y_coord)
    end
  end

  context '#==' do
    x_coord = 0
    y_coord = 0
    subject(:first_offset) { described_class.new([x_coord, y_coord])}
    let(:second_offset) { double(Offset) }

    it 'is not equal when x does not match' do
      allow(second_offset).to receive(:x).and_return(x_coord + 1)
      allow(second_offset).to receive(:y).and_return(y_coord)

      actual = (first_offset == second_offset)
      expect(actual).to be false
    end

    it 'is not equal when y does not match' do
      allow(second_offset).to receive(:x).and_return(x_coord)
      allow(second_offset).to receive(:y).and_return(y_coord + 1)

      actual = (first_offset == second_offset)
      expect(actual).to be false
    end

    it 'is equal when x and y match' do
      allow(second_offset).to receive(:x).and_return(x_coord)
      allow(second_offset).to receive(:y).and_return(y_coord)

      actual = (first_offset == second_offset)
      expect(actual).to be true
    end
  end
end