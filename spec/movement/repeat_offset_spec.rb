require_relative '../../lib/movement/repeat_offset'

describe RepeatOffset do
  context '#initialize' do
    x_coord = 0
    y_coord = 0
    max_repeats = 3
    subject(:new_offset) { described_class.new([x_coord, y_coord], max_repeats)}

    it 'sets x value with first array element' do
      actual = new_offset.x
      expect(actual).to eq(x_coord)
    end

    it 'sets y value with second array element' do
      actual = new_offset.y
      expect(actual).to eq(y_coord)
    end

    it 'sets max repeats value with second parameter' do
      actual = new_offset.max_repeats
      expect(actual).to eq(max_repeats)
    end

    it 'returns default max repeats when not supplied' do
      default_repeats = 100
      actual = RepeatOffset.new([x_coord, y_coord]).max_repeats

      expect(actual).to eq(default_repeats)
    end
  end

  context '#==' do
    x_coord = 0
    y_coord = 0
    max_repeats = 3
    subject(:first_offset) { described_class.new([x_coord, y_coord], max_repeats)}
    let(:second_offset) { double(Offset) }

    it 'is not equal when x does not match' do
      allow(second_offset).to receive(:x).and_return(x_coord + 1)
      allow(second_offset).to receive(:y).and_return(y_coord)
      allow(second_offset).to receive(:max_repeats).and_return(max_repeats)

      actual = (first_offset == second_offset)
      expect(actual).to be false
    end

    it 'is not equal when y does not match' do
      allow(second_offset).to receive(:x).and_return(x_coord)
      allow(second_offset).to receive(:y).and_return(y_coord + 1)
      allow(second_offset).to receive(:max_repeats).and_return(max_repeats)

      actual = (first_offset == second_offset)
      expect(actual).to be false
    end

    it 'is not equal when max_repeats do not match' do
      allow(second_offset).to receive(:x).and_return(x_coord)
      allow(second_offset).to receive(:y).and_return(y_coord)
      allow(second_offset).to receive(:max_repeats).and_return(max_repeats + 1)

      actual = (first_offset == second_offset)
      expect(actual).to be false
    end

    it 'is equal when x, y, and max repeats match' do
      allow(second_offset).to receive(:x).and_return(x_coord)
      allow(second_offset).to receive(:y).and_return(y_coord)
      allow(second_offset).to receive(:max_repeats).and_return(3)

      actual = (first_offset == second_offset)
      expect(actual).to be true
    end
  end
end