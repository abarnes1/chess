require_relative '../lib/threat_map'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/black_pawn'
require_relative '../lib/pieces/white_pawn'

describe ThreatMap do
  let(:black_player) { 'black' }
  let(:white_player) { 'white' }
  describe '#calculate' do
    context 'black: Rd7, Pe7 white: Pd2, Pd3' do
      context 'when calculating for black' do
        let(:black_pieces) {
          [Rook.new(position: Position.new('d7'), owner: black_player),
            BlackPawn.new(position: Position.new('e7'), owner: black_player)]
        }
  
        let(:white_pieces) {
          [WhitePawn.new(position: Position.new('d2'), owner: white_player),
            WhitePawn.new(position: Position.new('d3'), owner: white_player)]
        }
  
        subject(:threat_map) { described_class.new(black_pieces + white_pieces) }
    
        it 'returns the correct number of threatened positions' do
          actual = threat_map.calculate(black_pieces).size
          puts threat_map.calculate(black_pieces)
          
          expect(actual).to eq(10)
        end
    
        it 'includes covered squares' do
          actual = threat_map.calculate(black_pieces).include?(Position.new('e7'))

          expect(actual).to be true
        end
    
        it 'does not include squares past those covered' do
          actual = threat_map.calculate(black_pieces).include?(Position.new('f7'))

          expect(actual).to be false
        end
      end
    end
  end
end
