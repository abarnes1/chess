require_relative '../lib/half_move_clock'
require_relative '../lib/actions/capture'
require_relative '../lib/actions/promote_capture'
require_relative '../lib/pieces/white_pawn'
require_relative '../lib/pieces/black_pawn'

describe HalfMoveClock do
  describe '#capture?' do
    context 'action is a Capture' do
      subject(:half_move_clock) { described_class.new }

      let(:action) { double('action') }

      it 'returns true' do
        allow(action).to receive(:class).and_return(Capture)

        expect(half_move_clock.capture?(action)).to be true
      end
    end

    context 'action is a PromoteCapture' do
      subject(:half_move_clock) { described_class.new }

      let(:action) { double('action') }

      it 'returns true' do
        allow(action).to receive(:class).and_return(PromoteCapture)

        expect(half_move_clock.capture?(action)).to be true
      end
    end

    context 'action is another class' do
      subject(:half_move_clock) { described_class.new }

      let(:action) { double('action') }

      it 'returns false' do
        allow(action).to receive(:class).and_return(Object)

        expect(half_move_clock.capture?(action)).to be false
      end
    end
  end

  describe '#pawn_move?' do
    context 'piece is a WhitePawn' do
      subject(:half_move_clock) { described_class.new }

      let(:action) { double('action') }
      let(:piece) { double('piece') }

      it 'returns true' do
        allow(piece).to receive(:class).and_return(WhitePawn)
        allow(action).to receive(:piece).and_return(piece)

        expect(half_move_clock.pawn_move?(action)).to be true
      end
    end

    context 'piece is a BlackPawn' do
      subject(:half_move_clock) { described_class.new }

      let(:action) { double('action') }
      let(:piece) { double('piece') }

      it 'returns true' do
        allow(piece).to receive(:class).and_return(BlackPawn)
        allow(action).to receive(:piece).and_return(piece)

        expect(half_move_clock.pawn_move?(action)).to be true
      end
    end

    context 'piece is a Chesspiece' do
      subject(:half_move_clock) { described_class.new }

      let(:action) { double('action') }
      let(:piece) { double('piece') }

      it 'returns false' do
        allow(piece).to receive(:class).and_return(ChessPiece)
        allow(action).to receive(:piece).and_return(piece)

        expect(half_move_clock.pawn_move?(action)).to be false
      end
    end
  end

  describe '#update' do
    context 'action is a capture' do
      subject(:half_move_clock) { described_class.new(10) }

      let(:action) { double('action') }

      it 'resets the counter' do
        allow(half_move_clock).to receive(:pawn_move?)
        allow(half_move_clock).to receive(:capture?).and_return(true)

        expect {
          half_move_clock.update(action)
        }.to change { half_move_clock.counter }.from(10).to(0)
      end
    end

    context 'action is not a capture' do
      subject(:half_move_clock) { described_class.new(10) }

      let(:action) { double('action') }

      it 'increments the counter' do
        allow(half_move_clock).to receive(:pawn_move?)
        allow(half_move_clock).to receive(:capture?).and_return(false)

        expect {
          half_move_clock.update(action)
        }.to change { half_move_clock.counter }.from(10).to(11)
      end
    end

    context 'action is a pawn move' do
      subject(:half_move_clock) { described_class.new(10) }

      let(:action) { double('action') }

      it 'resets the counter' do
        allow(half_move_clock).to receive(:pawn_move?).and_return(true)
        allow(half_move_clock).to receive(:capture?)

        expect {
          half_move_clock.update(action)
        }.to change { half_move_clock.counter }.from(10).to(0)
      end
    end

    context 'action is not a pawn move' do
      subject(:half_move_clock) { described_class.new(10) }

      let(:action) { double('action') }
      
      it 'does not increments the counter' do
        allow(half_move_clock).to receive(:pawn_move?).and_return(false)
        allow(half_move_clock).to receive(:capture?)
        
        expect {
          half_move_clock.update(action)
        }.to change { half_move_clock.counter }.from(10).to(11)
      end
    end
  end
end