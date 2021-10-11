require_relative '../../lib/actions/castling.rb'

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
    # behavioral, ensure proper boolean logic when doubles
    # used to provide true/false for collaborators and other class methods
    
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
  end

  describe '#valid_partner?' do
    # behavior    
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
end

# valid initiator
# get valid partners
# determine if valid partner
#=> if both yes then return pair