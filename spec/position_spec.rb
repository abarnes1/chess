require_relative '../lib/position'

describe Position do
  context '#initialize' do
    subject(:position) { described_class.new('A1') }

    it 'downcases file (column)' do
      actual = position.file
      expect(actual).to eq('a')
    end

    it 'sets file (column) with first character' do
      actual = position.file
      expect(actual).to eq('a')
    end

    it 'sets rank (row) with second character' do
      actual = position.rank
      expect(actual).to eq('1')
    end
  end

  context '#==' do
    subject(:first_position) { described_class.new('a1') }
    let(:second_position) { double(Position) }

    it 'is equal when #position matches' do
      allow(second_position).to receive(:position).and_return('a1')

      actual = (first_position == second_position)
      expect(actual).to be true
    end

    it 'is not equal #position differs' do
      allow(second_position).to receive(:position).and_return('a2')

      actual = (first_position == second_position)
      expect(actual).to be false
    end
  end

  context '#inbounds?' do
    subject(:position) { described_class.new('a1') }

    it 'is false when file not between a and h' do
      allow(position).to receive(:file).and_return('z')

      expect(position).not_to  be_inbounds
    end

    it 'is false when rank not between 1 and 8' do
      allow(position).to receive(:rank).and_return('9')

      expect(position).not_to  be_inbounds
    end

    it 'is true when rank and file in range' do
      expect(position).to  be_inbounds
    end
  end
end
