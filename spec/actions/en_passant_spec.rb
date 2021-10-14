require_relative '../../lib/actions/en_passant.rb'
require_relative '../../lib/pieces/black_pawn'
require_relative '../../lib/pieces/white_pawn'

describe EnPassant do
  subject(:en_passant) {  described_class }
  let(:player1) { 'player1' }
  let(:player2) { 'player2' }

  describe '#valid_initiator?' do
    let(:initiator) { double('initiator') }

    context 'when piece is BlackPawn' do
      it 'returns false' do
        allow(initiator).to receive(:class).and_return(BlackPawn)
        actual = en_passant.valid_initiator?(initiator)
        expect(actual).to be true
      end
    end

    context 'when piece is WhitePawn' do
      it 'returns false' do
        allow(initiator).to receive(:class)
        actual = en_passant.valid_initiator?(initiator)
        expect(actual).to be false
      end
    end

    context 'when piece is something else' do
      it 'returns false' do
        allow(initiator).to receive(:class).and_return(Class.new)
        actual = en_passant.valid_initiator?(initiator)
        expect(actual).to be false
      end
    end
  end

  describe '#passed_capturable_square?' do
    context 'when initiator is WhitePawn' do
      let(:initiator) { WhitePawn.new(position: Position.new('b5'), owner: player1) }
      let(:target) { BlackPawn.new(position: Position.new('c5'), owner: player2) }

      context 'when last move passed capturable' do
        it 'returns true' do
          last_move = Move.new(target, Position.new('c7'), target.position)
          actual = en_passant.passed_capturable_square?(initiator, last_move)
          expect(actual).to be true
        end
      end

      context 'when last does not pass capturable' do
        it 'returns false' do
          last_move = Move.new(target, Position.new('c6'), target.position)
          actual = en_passant.passed_capturable_square?(initiator, last_move)
          expect(actual).to be false
        end
      end
    end

    context 'when initiator is BlackPawn' do
      let(:initiator) { BlackPawn.new(position: Position.new('c4'), owner: 'player1') }
      let(:target) { WhitePawn.new(position: Position.new('b4'), owner: 'player2') }

      context 'when last move passed capturable' do
        it 'returns true' do
          last_move = Move.new(target, Position.new('b2'), target.position)
          actual = en_passant.passed_capturable_square?(initiator, last_move)
          expect(actual).to be true
        end
      end

      context 'when last does not pass capturable' do
        it 'returns false' do
          last_move = Move.new(target, Position.new('b3'), target.position)
          actual = en_passant.passed_capturable_square?(initiator, last_move)
          expect(actual).to be false
        end
      end
    end

    context 'when last move is nil' do
      it 'returns nil' do
        initiator = BlackPawn.new(position: Position.new('c4'), owner: player1)
        last_move = nil
        actual = en_passant.passed_capturable_square?(initiator, last_move)
        expect(actual).to be_nil
      end
    end
  end

  describe '#move_enables_en_passant?' do
    # behavior verification, not state verification
    context 'when no actions have been taken' do
      let(:initiator) { double('WhitePawn') }

      it 'returns false' do
        action = nil
        allow(en_passant).to receive(:targets_valid_piece?).and_return(true)
        allow(en_passant).to receive(:two_space_move?).and_return(true)
        allow(en_passant).to receive(:passed_capturable_square?).and_return(true)
        expect(en_passant.move_enables_en_passant?(initiator, action)).to be false
      end
    end

    context 'when an action has been taken' do
      let(:action) { double('action') }
      let(:initiator) { double('WhitePawn') }

      before do
        allow(action).to receive(:piece)
      end

      context 'when not targeting valid piece' do
        it 'returns false when for invalid target piece' do
          allow(en_passant).to receive(:targets_valid_piece?).and_return(false)
          allow(en_passant).to receive(:two_space_move?).and_return(true)
          allow(en_passant).to receive(:passed_capturable_square?).and_return(true)
          expect(en_passant.move_enables_en_passant?(initiator, action)).to be false
        end
      end

      context 'when not a two space move' do
        it 'returns false' do
          allow(en_passant).to receive(:targets_valid_piece?).and_return(true)
          allow(en_passant).to receive(:two_space_move?).and_return(false)
          allow(en_passant).to receive(:passed_capturable_square?).and_return(true)
          expect(en_passant.move_enables_en_passant?(initiator, action)).to be false
        end
      end

      context 'when not passing a capturable square' do
        it 'returns false' do
          allow(en_passant).to receive(:targets_valid_piece?).and_return(true)
          allow(en_passant).to receive(:two_space_move?).and_return(true)
          allow(en_passant).to receive(:passed_capturable_square?).and_return(false)
          expect(en_passant.move_enables_en_passant?(initiator, action)).to be false
        end
      end

      context 'when passing all criteria' do
        it 'returns true' do
          allow(en_passant).to receive(:targets_valid_piece?).and_return(true)
          allow(en_passant).to receive(:two_space_move?).and_return(true)
          allow(en_passant).to receive(:passed_capturable_square?).and_return(true)
          expect(en_passant.move_enables_en_passant?(initiator, action)).to be true
        end
      end
    end
  end

  describe '#targets_valid_piece?' do
    context 'when pieces have different owner' do
      context 'when initiator is BlackPawn' do
        let(:initiator) { BlackPawn.new(owner: player1) }
  
        it 'returns true for WhitePawn target' do
          target = WhitePawn.new(owner: player2)
          expect(en_passant.targets_valid_piece?(initiator, target)).to be true
        end
  
        it 'returns false for something else' do
          target = double('target')
          allow(target).to receive(:owner).and_return(player2)
          expect(en_passant.targets_valid_piece?(initiator, target)).to be false
        end
      end
  
      context 'when initiator is WhitePawn' do
        let(:initiator) { WhitePawn.new(owner: player1) }
  
        it 'returns true for BlackPawn target' do
          target = BlackPawn.new(owner: player2)
          expect(en_passant.targets_valid_piece?(initiator, target)).to be true
        end
  
        it 'returns false for something else' do
          target = double('target')
          allow(target).to receive(:owner).and_return(player2)
          expect(en_passant.targets_valid_piece?(initiator, target)).to be false
        end
      end
    end

    context 'when pieces have same owner' do
      it 'returns false' do
        initiator = WhitePawn.new(owner: player1)
        target = WhitePawn.new(owner: player2)
        expect(en_passant.targets_valid_piece?(initiator, target)).to be false
      end
    end
  end

  describe '#two_space_move?' do
    context 'when action was a Move' do
      context 'when action was 2 spaces' do
        it 'returns false for a2 to a4' do
          action = Move.new(nil, Position.new('a2'), Position.new('a4'))
          expect(en_passant.two_space_move?(action)).to be true
        end

        it 'returns false for a1 to a4' do
          action = Move.new(nil, Position.new('a1'), Position.new('a4'))
          expect(en_passant.two_space_move?(action)).to be false
        end
      end
    end

    context 'when last action was not a Move' do
      it 'returns false for a2 to a4' do
        action = double('action') do
        allow(action).to receive(:is_a?).with(Move).and_return(false)
        expect(en_passant.two_space_move?(action)).to be false
        end
      end
    end
  end

  context '#create_for' do
    
  end
end