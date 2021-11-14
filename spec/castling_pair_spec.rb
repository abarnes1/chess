require_relative '../lib/castling_pair'

describe CastlingPair do
  describe 'enabled' do
    context 'when no updates have been made' do
      let(:king_position) { Position.new('e1') }
      let(:rook_position) { Position.new('a1') }

      let(:pair) { described_class.new(king_position, rook_position) }

      it 'returns true' do
        expect(pair).to be_enabled
      end  
    end

    context 'when update matches king position' do
      let(:king_position) { Position.new('e1') }
      let(:rook_position) { Position.new('a1') }

      let(:pair) { described_class.new(king_position, rook_position) }

      it 'returns false' do
        pair.update(Position.new('e1'))

        expect(pair).not_to be_enabled
      end  
    end

    context 'when update matches rook position' do
      let(:king_position) { Position.new('e1') }
      let(:rook_position) { Position.new('a1') }

      let(:pair) { described_class.new(king_position, rook_position) }

      it 'returns false' do
        pair.update(Position.new('a1'))

        expect(pair).not_to be_enabled
      end  
    end
  end
end