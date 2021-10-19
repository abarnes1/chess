require_relative '../../lib/actions/move'
require_relative '../../lib/pieces/chesspiece'

describe Capture do
  describe '#apply' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:capturing) { ChessPiece.new }
    let(:captured) { ChessPiece.new }
    let(:game_state) { double('game_state') }

    subject(:apply_capture) { described_class.new(capturing, move_from, move_to, captured)}

    before do
      allow(game_state).to receive(:add_piece)
      allow(game_state).to receive(:remove_piece)

      capturing.position = move_from
      captured.position = move_to
    end

    it 'moves the capturing piece to new position' do
      expect {
        apply_capture.apply(game_state)
      }.to change { capturing.position }.from(move_from).to(move_to)
    end

    it 'removes the captured piece' do
      expect(game_state).to receive(:remove_piece).with(captured).once

      apply_capture.apply(game_state)
    end
  end

  describe '#undo' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:capturing) { ChessPiece.new }
    let(:captured) { ChessPiece.new }
    let(:game_state) { double('game_state') }

    subject(:undo_capture) { described_class.new(capturing, move_from, move_to, captured)}

    before do
      allow(game_state).to receive(:add_piece)
      allow(game_state).to receive(:remove_piece)
      
      capturing.position = move_to
    end

    it 'returnes the capturing piece to original position' do
      expect {
        undo_capture.undo(game_state)
      }.to change { capturing.position }.from(move_to).to(move_from)
    end

    it 'adds the captured piece back to the game' do
      expect(game_state).to receive(:add_piece).with(captured).once

      undo_capture.undo(game_state)
    end
  end

  describe '#to_s' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:capturing) { double('capturing', to_s: 'x') }
    let(:captured) { double('captured', to_s: 'y', position: Position.new('c2')) }

    subject(:capture) { described_class.new(capturing, move_from, move_to, captured) }

    it 'returns the correct string' do
      expected = "capture: #{capturing} from #{move_from} to #{move_to} and capture #{captured}"

      actual = capture.to_s
      expect(actual).to eq(expected)
    end
  end

  describe '#notation' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:capturing) { double('piece', notation_letter: 'K') }
    let(:captured) { double('captured') }

    subject(:move) { described_class.new(capturing, move_from, move_to, captured) }

    it 'returns the correct string' do
      expected = "#{capturing.notation_letter}x#{move_to}"

      actual = move.notation
      expect(actual).to eq(expected)
    end
  end
end