require_relative '../../lib/actions/castling'
require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/rook'
require_relative '../../lib/board_data'

describe Castling do
  describe '#apply' do
    let(:king_move_from) { Position.new('e1') }
    let(:king_move_to) { Position.new('c1') }
    let(:king) { King.new }

    let(:rook_move_from) { Position.new('a1')}
    let(:rook_move_to) { Position.new('d1')}
    let(:rook) { Rook.new }
    let(:board_data) { BoardData.new }

    subject(:apply_castling) { described_class.new(king, king_move_from, king_move_to, rook, rook_move_to) }

    before do
      king.position = king_move_from
      rook.position = rook_move_from

      board_data.add_piece(king)
      board_data.add_piece(rook)
    end

    it 'moves the king to new position' do
      expect {
        apply_castling.apply(board_data)
      }.to change { king.position }.from(king_move_from).to(king_move_to)
    end

    it 'moves the rook to new position' do
      expect {
        apply_castling.apply(board_data)
      }.to change { rook.position }.from(rook_move_from).to(rook_move_to)
    end
  end

  describe '#undo' do
    let(:board_data) { BoardData.new }

    it 'moves the initiating piece to back to original position' do
      king_move_from = Position.new('e1')
      king_move_to = Position.new('c1')
      king = King.new(position: king_move_from)

      rook_move_from = Position.new('a1')
      rook_move_to = Position.new('d1')
      rook = Rook.new(position: rook_move_from)
      
      undo_castling = described_class.new(king, king_move_from, king_move_to, rook, rook_move_to)
      undo_castling.apply(board_data)

      expect {
        undo_castling.undo(board_data)
      }.to change { king.position }.from(king_move_to).to(king_move_from)
    end

    it 'moves the partner piece to back to original position' do
      king_move_from = Position.new('e1')
      king_move_to = Position.new('c1')
      king = King.new(position: king_move_from)

      rook_move_from = Position.new('a1')
      rook_move_to = Position.new('d1')
      rook = Rook.new(position: rook_move_from)
      
      undo_castling = described_class.new(king, king_move_from, king_move_to, rook, rook_move_to)
      undo_castling.apply(board_data)

      expect {
        undo_castling.undo(board_data)
      }.to change { rook.position }.from(rook_move_to).to(rook_move_from)
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