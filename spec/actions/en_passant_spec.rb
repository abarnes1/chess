require_relative '../../lib/actions/en_passant.rb'
require_relative '../../lib/pieces/black_pawn'
require_relative '../../lib/pieces/white_pawn'

describe EnPassant do
  subject(:en_passant) {  described_class }

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

  describe '#last_action_by_enemy?' do
    let(:initiator) { double('initiator') }
    let(:target) { double('target') }
    let(:last_action) { double('last_action') }
    let(:friendly_owner)  { 'player1' }
    let(:enemy_owner)  { 'player2' }

    before do
      allow(initiator).to receive(:owner).and_return(friendly_owner)
      allow(last_action).to receive(:piece).and_return(target)
    end

    context 'when action by enemy' do
      it 'returns true' do
        allow(target).to receive(:owner).and_return(enemy_owner)
        actual = en_passant.last_action_by_enemy?(initiator, target)
        expect(actual).to be true
      end
    end

    context 'when action by friendly' do
      it 'returns false' do
        allow(target).to receive(:owner).and_return(friendly_owner)
        actual = en_passant.last_action_by_enemy?(initiator, target)
        expect(actual).to be false
      end
    end
  end

  describe '#passed_capturable?' do
    context 'when initiator is WhitePawn' do
      let(:initiator) { WhitePawn.new(position: Position.new('b5'), owner: 'player1') }
      let(:target) { BlackPawn.new(position: Position.new('c5'), owner: 'player2') }

      context 'when last move passed capturable' do
        it 'returns true' do
          last_move = Move.new(target, Position.new('c7'), target.position)
          actual = en_passant.passed_capturable?(initiator, last_move)
          expect(actual).to be true
        end
      end

      context 'when last does not pass capturable' do
        it 'returns false' do
          last_move = Move.new(target, Position.new('c6'), target.position)
          actual = en_passant.passed_capturable?(initiator, last_move)
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
          actual = en_passant.passed_capturable?(initiator, last_move)
          expect(actual).to be true
        end
      end

      context 'when last does not pass capturable' do
        it 'returns false' do
          last_move = Move.new(target, Position.new('b3'), target.position)
          actual = en_passant.passed_capturable?(initiator, last_move)
          expect(actual).to be false
        end
      end
    end

    context 'when initator is not a pawn' do
      let(:initiator) { double('intiator') }
      let(:target) { WhitePawn.new(position: Position.new('b4'), owner: 'player2') }
      let(:last_move) { nil }

      it 'returns nil' do
        actual = en_passant.passed_capturable?(initiator, last_move)
        expect(actual).to be_nil
      end
    end

    context 'when target is not a pawn' do
      let(:initiator) { BlackPawn.new(position: Position.new('c4'), owner: 'player1') }
      let(:target) { double('target') }
      let(:last_move) { double('last move') }

      it 'returns nil' do
        allow(last_move).to receive(:piece).and_return(target)
        actual = en_passant.passed_capturable?(initiator, last_move)
        expect(actual).to be_nil
      end
    end

    context 'when last move is nil' do
      let(:initiator) { BlackPawn.new(position: Position.new('c4'), owner: 'player1') }
      let(:target) { double('target') }
      let(:last_move) { double('last move') }

      it 'returns nil' do
        allow(last_move).to receive(:piece).and_return(target)
        actual = en_passant.passed_capturable?(initiator, last_move)
        expect(actual).to be_nil
      end
    end
  end

  describe '#last_move_enables_en_passant?' do
    let(:initiator) { double('initiator') }
    let(:last_action) { double('last_action') }
    let(:target) { double('target') }

    context 'when no actions have been taken' do
      before do
        allow(en_passant).to receive(:last_action_by_enemy?).and_return(true)
        allow(en_passant).to receive(:valid_target?).and_return(true)
        allow(en_passant).to receive(:passed_capturable?).and_return(true)
      end

      it 'returns false' do
        last_action = nil
        actual = en_passant.last_move_enables_en_passant?(initiator, last_action)
        expect(actual).to be false
      end
    end

    context 'when last move not made by targetable piece' do
      before do
        allow(en_passant).to receive(:last_action_by_enemy?).and_return(true)
        allow(en_passant).to receive(:valid_target?).and_return(false)
        allow(en_passant).to receive(:passed_capturable?).and_return(true)
      end

      it 'returns false' do
        allow(last_action).to receive(:piece).and_return(target)

        actual = en_passant.last_move_enables_en_passant?(initiator, last_action)

        expect(actual).to be false
      end
    end

    context 'when target is invalid class' do
      before do
        allow(en_passant).to receive(:last_action_by_enemy?).and_return(true)
        allow(en_passant).to receive(:valid_target?).and_return(false)
        allow(en_passant).to receive(:passed_capturable?).and_return(true)
      end

      it 'returns false' do
        allow(last_action).to receive(:piece).and_return(target)

        actual = en_passant.last_move_enables_en_passant?(initiator, last_action)

        expect(actual).to be false
      end
    end

    context 'when last action did not pass capturable position' do
      before do
        allow(en_passant).to receive(:last_action_by_enemy?).and_return(true)
        allow(en_passant).to receive(:valid_target?).and_return(true)
        allow(en_passant).to receive(:passed_capturable?).and_return(false)
      end

      it 'returns false' do
        allow(last_action).to receive(:piece).and_return(target)
        actual = en_passant.last_move_enables_en_passant?(initiator, last_action)

        expect(actual).to be false
      end
    end
  end

  describe '#valid_target?' do
    let(:initiator) { double('initiator') }
    let(:target) { double('target') }

    context 'when piece is a WhitePawn' do
      before do
        allow(initiator).to receive(:is_a?).with(WhitePawn).and_return(true)
        allow(initiator).to receive(:is_a?).with(BlackPawn).and_return(false)
      end

      context 'when target is BlackPawn' do
        it 'returns true' do
          allow(target).to receive(:is_a?).with(BlackPawn).and_return(true)
          allow(target).to receive(:is_a?).with(WhitePawn).and_return(false)
          actual = en_passant.valid_target?(initiator, target)
          expect(actual).to be true
        end
      end

      context 'when target is WhitePawn' do
        it 'returns false' do
          allow(target).to receive(:is_a?).with(WhitePawn).and_return(true)
          allow(target).to receive(:is_a?).with(BlackPawn).and_return(false)
          actual = en_passant.valid_target?(initiator, target)
          expect(actual).to be false
        end
      end
    end

    context 'when piece is a BlackPawn' do
      before do
        allow(initiator).to receive(:is_a?).with(BlackPawn).and_return(true)
        allow(initiator).to receive(:is_a?).with(WhitePawn).and_return(false)
      end

      context 'when target is WhitePawn' do
        it 'returns true' do
          allow(target).to receive(:is_a?).with(BlackPawn).and_return(false)
          allow(target).to receive(:is_a?).with(WhitePawn).and_return(true)
          actual = en_passant.valid_target?(initiator, target)
          expect(actual).to be true
        end
      end

      context 'when target is BlackPawn' do
        it 'returns false' do
          allow(target).to receive(:is_a?).with(BlackPawn).and_return(true)
          allow(target).to receive(:is_a?).with(WhitePawn).and_return(false)
          actual = en_passant.valid_target?(initiator, target)
          expect(actual).to be false
        end
      end
    end
  end

  context '#create_for' do
    
  end
end