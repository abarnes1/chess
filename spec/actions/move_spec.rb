require_relative '../../lib/actions/move'
require_relative '../../lib/pieces/chesspiece'
require_relative '../../lib/board_data'

describe Move do
  describe '#apply' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:piece) { ChessPiece.new }
    let(:board_data) { BoardData.new }

    subject(:apply_move) { described_class.new(piece, move_from, move_to)}

    before do
      piece.position = move_from
      board_data.add_piece(piece)
    end

    it 'moves the piece to new position' do
      expect {
        apply_move.apply(board_data)
      }.to change { piece.position }.from(move_from).to(move_to)
    end
  end

  describe '#undo' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:piece) { ChessPiece.new }
    let(:board_data) { BoardData.new }

    subject(:apply_move) { described_class.new(piece, move_from, move_to)}

    before do
      piece.position = move_to
      board_data.add_piece(piece)
    end

    it 'moves the piece back to original position' do
      expect {
        apply_move.undo(board_data)
      }.to change { piece.position }.from(move_to).to(move_from)
    end
  end
  

  describe '#to_s' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:piece) { double('piece', to_s: 'x') }

    subject(:move) { described_class.new(piece, move_from, move_to) }

    it 'returns the correct string' do
      expected = "move: #{piece} from #{move_from} to #{move_to}"

      actual = move.to_s
      expect(actual).to eq(expected)
    end
  end

  describe '#notation' do
    let(:move_from) { Position.new('b2') }
    let(:move_to) { Position.new('b3') }
    let(:piece) { double('piece', notation_letter: 'X', position: move_from) }

    subject(:move) { described_class.new(piece, move_from, move_to) }

    it 'returns the correct string' do
      expected = "#{piece.notation_letter}#{move_to}"

      actual = move.notation
      expect(actual).to eq(expected)
    end
  end
end