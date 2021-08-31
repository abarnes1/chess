require_relative '../lib/pieces/bishop'

describe Bishop do
  context 'it includes PositionHelpers module' do
    subject(:module_test) { described_class.new }
    it 'responds to #inbounds?' do
      expect(described_class.new).to respond_to(:inbounds?)
    end

    it 'responds to #calculate_position' do
      expect(described_class.new).to respond_to(:calculate_position)
    end
  end

  describe '#possible_moves' do
    context 'when on square c4' do
      context 'up + right diagonals: movement is [1, 1]' do
        subject(:up_right_bishop) { described_class.new('c4') }
        let(:up_right_moves) { up_right_bishop.possible_moves }

        it 'can move to d5' do
          expect(up_right_moves).to include('d5')
        end

        it 'can move to e6' do
          expect(up_right_moves).to include('e6')
        end

        it 'can move to f7' do
          expect(up_right_moves).to include('f7')
        end

        it 'can move to g8' do
          expect(up_right_moves).to include('g8')
        end
      end
    end

    context 'when on square c4' do
      context 'up + right diagonals: movement is [1, -1]' do
        subject(:down_right_bishop) { described_class.new('c4') }
        let(:down_right_moves) { down_right_bishop.possible_moves }

        it 'can move to d3' do
          expect(down_right_moves).to include('d3')
        end

        it 'can move to e2' do
          expect(down_right_moves).to include('e2')
        end

        it 'can move to f1' do
          expect(down_right_moves).to include('f1')
        end
      end
    end
  end
end