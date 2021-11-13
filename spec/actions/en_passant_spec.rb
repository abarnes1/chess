require_relative '../../lib/actions/en_passant'
require_relative '../../lib/pieces/black_pawn'
require_relative '../../lib/pieces/white_pawn'
require_relative '../../lib/board_data'

describe EnPassant do
  subject(:en_passant) {  described_class }
  let(:player1) { 'player1' }
  let(:player2) { 'player2' }

  describe '#valid_initiator?' do
    let(:initiator) { double('initiator') }

    context 'when piece is BlackPawn' do
      it 'returns true' do
        allow(initiator).to receive(:class).and_return(BlackPawn)
        actual = en_passant.valid_initiator?(initiator)
        expect(actual).to be true
      end
    end

    context 'when piece is WhitePawn' do
      it 'returns true' do
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

  describe '#apply' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('c3') }
    let(:capturing) { ChessPiece.new }
    let(:captured) { ChessPiece.new }
    let(:board_data) { BoardData.new }

    subject(:apply_en_passant) { described_class.new(capturing, move_from, move_to, captured)}

    before do
      capturing.position = move_from
      captured.position = move_to
    end

    it 'moves the capturing piece to new position' do
      expect {
        apply_en_passant.apply(board_data)
      }.to change { capturing.position }.from(move_from).to(move_to)
    end

    it 'removes the captured piece' do
      allow(board_data).to receive(:move)
      expect(board_data).to receive(:remove_piece).with(captured).once

      apply_en_passant.apply(board_data)
    end
  end

  describe '#undo' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('c3') }
    let(:capturing) { ChessPiece.new }
    let(:captured) { ChessPiece.new }
    let(:board_data) { BoardData.new }

    subject(:undo_en_passant) { described_class.new(capturing, move_from, move_to, captured)}

    before do
      allow(board_data).to receive(:add_piece)
      allow(board_data).to receive(:remove_piece)

      capturing.position = move_from
      captured.position = move_to

      undo_en_passant.apply(board_data)
    end

    it 'returns the capturing piece to original position' do
      expect {
        undo_en_passant.undo(board_data)
      }.to change { capturing.position }.from(move_to).to(move_from)
    end

    it 'adds the captured piece' do
      expect(board_data).to receive(:add_piece).with(captured)

      undo_en_passant.undo(board_data)
    end
  end

  describe '#to_s' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('c3') }
    let(:capturing) { double('capturing', to_s: 'x') }
    let(:captured) { double('captured', to_s: 'y', position: Position.new('c2')) }

    subject(:en_passant) { described_class.new(capturing, move_from, move_to, captured)}

    it 'returns the correct string' do
      expected = "en passant capture: #{capturing} from #{move_from} to #{move_to} and capture #{captured} at #{captured.position}"

      actual = en_passant.to_s
      expect(actual).to eq(expected)
    end
  end

  describe '#notation' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('c3') }
    let(:capturing) { double('capturing', to_s: 'x', position: move_from) }
    let(:captured) { double('captured', to_s: 'y', position: Position.new('c2')) }

    subject(:en_passant) { described_class.new(capturing, move_from, move_to, captured)}

    it 'returns the correct string' do
      expected = "#{capturing.position.file}x#{move_to} e.p."

      actual = en_passant.notation
      expect(actual).to eq(expected)
    end
  end
end