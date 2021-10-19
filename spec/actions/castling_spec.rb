require_relative '../../lib/actions/castling'
require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/rook'

describe Castling do
  subject(:castling) {  described_class }
  
  describe '#valid_initiator_position?' do
    context 'when position invalid' do
      position_to_test = Position.new('a1')

      it "returns false for #{position_to_test}" do
        actual = castling.valid_initiator_position?(position_to_test)
        expect(actual).to be false
      end
    end

    context 'when position is valid' do
      position_to_test = Position.new('e1')

      it "returns true for #{position_to_test}" do
        actual = castling.valid_initiator_position?(position_to_test)
        expect(actual).to be true
      end

      position_to_test = Position.new('e8')

      it "returns true for #{position_to_test}" do
        actual = castling.valid_initiator_position?(position_to_test)
        expect(actual).to be true
      end
    end
  end

  describe '#valid_initiator?' do
    context 'when piece does not know if it can initiate' do
      let(:initiator) { double('initiator') }
      let(:game_state) { double('game_state') }

      it 'returns false' do
        actual = castling.valid_initiator?(initiator, game_state)
        expect(actual).to be false
      end
    end

    context 'when piece can initiate' do
      let(:initiator) { double('initiator') }
      let(:game_state) { double('game_state') }

      before(:each) do
        allow(initiator).to receive(:initiates_castling?).and_return(true)
        allow(initiator).to receive(:position)
      end

      context 'when not in valid position to initiate' do
        it 'returns false' do
          allow(castling).to receive(:valid_initiator_position?).and_return(false)
  
          actual = castling.valid_initiator?(initiator, game_state)
          expect(actual).to be false
        end
      end

      context 'when in valid position to initiate' do
        before do
          allow(castling).to receive(:valid_initiator_position?).and_return(true)  
        end

        context 'when initiator has moved' do
          it 'returns false' do
            allow(game_state).to receive(:moved?).and_return(true)

            actual = castling.valid_initiator?(initiator, game_state)
            expect(actual).to be false
          end
        end

        context 'when initiator has not moved' do
          it 'returns true' do
            allow(game_state).to receive(:moved?).and_return(false)

            actual = castling.valid_initiator?(initiator, game_state)
            expect(actual).to be true
          end
        end
      end
    end
  end

  describe '#valid_partner_position?' do
    context 'when initiator on e1' do
      let(:initiator) { Position.new('e1') }

      context 'when position invalid' do
        it 'returns false for e8' do
          partner = Position.new('e8')

          actual = castling.valid_partner_position?(initiator, partner)
          expect(actual).to be false
        end
      end
  
      context 'when position is valid' do
        it 'returns true for a1' do
          partner = Position.new('a1')

          actual = castling.valid_partner_position?(initiator, partner)
          expect(actual).to be true
        end
  
        it 'returns true for h1' do
          partner = Position.new('h1')

          actual = castling.valid_partner_position?(initiator, partner)
          expect(actual).to be true
        end
      end
    end

    context 'when initiator on e8' do
      let(:initiator) { Position.new('e8') }

      context 'when position invalid' do
        it 'returns false for e1' do
          partner = Position.new('e1')

          actual = castling.valid_partner_position?(initiator, partner)
          expect(actual).to be false
        end
      end
  
      context 'when position is valid' do
        it 'returns true for a8' do
          partner = Position.new('a8')

          actual = castling.valid_partner_position?(initiator, partner)
          expect(actual).to be true
        end
  
        it 'returns true for h8' do
          partner = Position.new('h8')

          actual = castling.valid_partner_position?(initiator, partner)
          expect(actual).to be true
        end
      end
    end

    context 'when initiator on c4' do
      it 'returns false' do
        initiator = Position.new('c4')
        partner = Position.new('a1')

        actual = castling.valid_partner_position?(initiator, partner)
        expect(actual).to be false
      end
    end
  end

  describe '#valid_partner?' do
    # behavior - return correct boolean value depending on sub functions
    context 'when piece does not know if it can partner' do
      let(:initiator) { double('initiator') }
      let(:partner) { double('partner') }
      let(:game_state) { double('game_state') }

      it 'returns false' do
        actual = castling.valid_partner?(initiator, partner, game_state)
        expect(actual).to be false
      end
    end

    context 'when piece can partner' do
      let(:initiator) { double('initiator') }
      let(:partner) { double('partner') }
      let(:game_state) { double('game_state') }

      before do
        allow(partner).to receive(:castling_partner?).and_return(true)
        allow(initiator).to receive(:position)
        allow(partner).to receive(:position)
      end

      context 'when not in valid position to partner' do
        it 'returns false' do
          allow(castling).to receive(:valid_partner_position?).and_return(false)
  
          actual = castling.valid_partner?(initiator, partner, game_state)
          expect(actual).to be false
        end
      end

      context 'when in valid position to partner' do
        before do
          allow(castling).to receive(:valid_partner_position?).and_return(true)  
        end

        context 'when partner has moved' do
          it 'returns false' do
            allow(game_state).to receive(:moved?).and_return(true)

            actual = castling.valid_partner?(initiator, partner, game_state)
            expect(actual).to be false
          end
        end

        context 'when partner has not moved' do
          it 'returns true' do
            allow(game_state).to receive(:moved?).and_return(false)
            
            actual = castling.valid_partner?(initiator, partner, game_state)
            expect(actual).to be true
          end
        end
      end
    end
  end

  describe '#apply' do
    let(:initiator_move_from) { Position.new('e1') }
    let(:initiator_move_to) { Position.new('c1') }
    let(:initiator) { ChessPiece.new }

    let(:partner_move_from) { Position.new('a1')}
    let(:partner_move_to) { Position.new('d1')}
    let(:partner) { ChessPiece.new }
    let(:game_state) { double('game_state') }

    subject(:apply_castling) { described_class.new(initiator, initiator_move_from, initiator_move_to, partner, partner_move_to) }

    before do
      initiator.position = initiator_move_from
      partner.position = partner_move_from
    end

    it 'moves the initiating piece to new position' do
      expect {
        apply_castling.apply(game_state)
      }.to change { initiator.position }.from(initiator_move_from).to(initiator_move_to)
    end

    it 'moves the partner piece to new position' do
      expect {
        apply_castling.apply(game_state)
      }.to change { partner.position }.from(partner_move_from).to(partner_move_to)
    end
  end

  describe '#undo' do
    # The way position is handled internally for Castling makes reusable 
    # let variables not really work, test with real objects set up within
    # each test's it block or without a previous call to #apply to set
    # internal state.
    
    let(:game_state) { double('game_state') }

    it 'moves the initiating piece to back to original position' do
      initiator_move_from = Position.new('e1')
      initiator_move_to = Position.new('c1')
      initiator = ChessPiece.new(position: initiator_move_from)

      partner_move_from = Position.new('a1')
      partner_move_to = Position.new('d1')
      partner = ChessPiece.new(position: partner_move_from)
      
      undo_castling = described_class.new(initiator, initiator_move_from, initiator_move_to, partner, partner_move_to)
      undo_castling.apply(game_state)

      expect {
        undo_castling.undo(game_state)
      }.to change { initiator.position }.from(initiator_move_to).to(initiator_move_from)
    end

    it 'moves the partner piece to back to original position' do
      initiator_move_from = Position.new('e1')
      initiator_move_to = Position.new('c1')
      initiator = ChessPiece.new(position: initiator_move_from)

      partner_move_from = Position.new('a1')
      partner_move_to = Position.new('d1')
      partner = ChessPiece.new(position: partner_move_from)
      
      undo_castling = described_class.new(initiator, initiator_move_from, initiator_move_to, partner, partner_move_to)
      undo_castling.apply(game_state)

      expect {
        undo_castling.undo(game_state)
      }.to change { partner.position }.from(partner_move_to).to(partner_move_from)
    end
  end

  describe '#to_s' do
    it 'returns the correct string' do
      initiator_move_from = Position.new('e1')
      initiator_move_to = Position.new('c1')
      initiator = ChessPiece.new(position: initiator_move_from, icon: 'X')
  
      partner_move_from = Position.new('a1')
      partner_move_to = Position.new('d1')
      partner = ChessPiece.new(position: partner_move_from, icon: 'Y')
  
      castling = described_class.new(initiator, initiator_move_from, initiator_move_to, partner, partner_move_to)

      expected = "castling: #{initiator} from #{initiator_move_from} to #{initiator_move_to}, " \
      "#{partner} from #{partner_move_from} to #{partner_move_to}"

      actual = castling.to_s

      expect(actual).to eq(expected)
    end
  end

  describe '#notation' do
    it 'returns the correct string for queen side' do
      initiator_move_from = Position.new('e1')
      initiator_move_to = Position.new('c1')
      initiator = ChessPiece.new(position: initiator_move_from, icon: 'X')
  
      partner_move_from = Position.new('a1')
      partner_move_to = Position.new('d1')
      partner = ChessPiece.new(position: partner_move_from, icon: 'Y')
  
      castling = described_class.new(initiator, initiator_move_from, initiator_move_to, partner, partner_move_to)

      expected = '0-0-0'
      actual = castling.notation

      expect(actual).to eq(expected)
    end

    it 'returns the correct string for king side' do
      initiator_move_from = Position.new('e1')
      initiator_move_to = Position.new('g1')
      initiator = ChessPiece.new(position: initiator_move_from, icon: 'X')
  
      partner_move_from = Position.new('h1')
      partner_move_to = Position.new('f1')
      partner = ChessPiece.new(position: partner_move_from, icon: 'Y')
  
      castling = described_class.new(initiator, initiator_move_from, initiator_move_to, partner, partner_move_to)

      expected = '0-0'
      actual = castling.notation

      expect(actual).to eq(expected)
    end
  end
end