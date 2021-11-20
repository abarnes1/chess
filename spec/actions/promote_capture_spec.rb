require_relative '../../lib/actions/promote_capture'
require_relative '../../lib/pieces/chesspiece'

describe PromoteCapture do
  describe '#apply' do
    let(:move_from) { Position.new('a7') }
    let(:move_to) { Position.new('a8') }
    let(:game_state) { double('game_state') }
    let(:promotable) { ChessPiece.new }
    let(:captured) { ChessPiece.new }
    let(:promote_to) { ChessPiece.new }

    before do
      allow(game_state).to receive(:add_piece)
      allow(game_state).to receive(:remove_piece)
    end

    it 'removes the promotable piece' do
      apply_promote_capture = described_class.new(promotable, move_from, move_to, captured, promote_to)

      expect(game_state).to receive(:remove_piece).with(promotable)

      apply_promote_capture.apply(game_state)
    end

    it 'removes the captured piece' do
      apply_promote_capture = described_class.new(promotable, move_from, move_to, captured, promote_to)

      expect(game_state).to receive(:remove_piece).with(captured)

      apply_promote_capture.apply(game_state)
    end

    it 'adds the promoted to piece' do
      apply_promote_capture = described_class.new(promotable, move_from, move_to, captured, promote_to)

      expect(game_state).to receive(:add_piece).with(promote_to)

      apply_promote_capture.apply(game_state)
    end

    it 'the promoted to piece is at the correct destination' do
      apply_promote_capture = described_class.new(promotable, move_from, move_to, captured, promote_to)

      expect {
        apply_promote_capture.apply(game_state)
      }.to change { promote_to.position }.from(nil).to(move_to)
    end
  end

  describe '#undo' do
    let(:move_from) { Position.new('a7') }
    let(:move_to) { Position.new('a8') }
    let(:game_state) { double('game_state') }
    let(:promotable) { ChessPiece.new }
    let(:captured) { ChessPiece.new }
    let(:promote_to) { ChessPiece.new }

    before do
      allow(game_state).to receive(:add_piece)
      allow(game_state).to receive(:remove_piece)
    end

    it 'removes the promoted to piece' do
      undo_promote_capture = described_class.new(promotable, move_from, move_to, captured, promote_to)

      expect(game_state).to receive(:remove_piece).with(promote_to)

      undo_promote_capture.undo(game_state)
    end

    it 'adds the promotable piece' do
      undo_promote_capture = described_class.new(promotable, move_from, move_to, captured, promote_to)

      expect(game_state).to receive(:add_piece).with(captured)

      undo_promote_capture.undo(game_state)
    end

    it 'adds the captured piece' do
      undo_promote_capture = described_class.new(promotable, move_from, move_to, captured, promote_to)

      expect(game_state).to receive(:add_piece).with(promotable)

      undo_promote_capture.undo(game_state)
    end
  end

  describe '#to_s' do
    let(:move_from) { Position.new('a7') }
    let(:move_to) { Position.new('a8') }
    let(:game_state) { double('game_state') }
    let(:promotable) { double('promotable', to_s: 'piece1') }
    let(:captured) { double('captured', to_s: 'captured') }
    let(:promote_to) { double('promote_to', to_s: 'piece2') }

    subject(:promote_capture) { described_class.new(promotable, move_from, move_to, captured, promote_to) }

    it 'returns the correct string' do
      expected = "promote capture: #{promotable} to #{promote_to} at #{move_to}"

      actual = promote_capture.to_s
      expect(actual).to eq(expected)
    end
  end

  describe '#notation' do
    let(:move_from) { Position.new('a7') }
    let(:move_to) { Position.new('a8') }
    let(:game_state) { double('game_state') }
    let(:promotable) { double('promotable', to_s: 'piece1') }
    let(:captured) { double('captured', to_s: 'captured') }
    let(:promote_to) { double('promote_to', to_s: 'piece2') }

    subject(:promote_capture) { described_class.new(promotable, move_from, move_to, captured, promote_to) }

    it 'returns the correct string' do
      expected = "#{move_from}x#{move_to}=#{promote_to}"

      actual = promote_capture.notation
      expect(actual).to eq(expected)
    end
  end
end