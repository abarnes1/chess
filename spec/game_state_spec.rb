require_relative '../lib/game_state'

describe GameState do
  let(:white_player) { double('white_player') }
  let(:black_player) { double('black_player') }

  describe '#add_piece' do
    subject(:game_state) { described_class.new(white: white_player) }

    before do
      game_state.add_piece(ChessPiece.new(position: Position.new('a1'), owner: white_player))
    end

    it 'adds the piece' do
      actual = game_state.pieces.size

      expect(actual).to eq(1)
    end
  end

  describe '#remove_piece' do
    subject(:game_state) { described_class.new(white: white_player) }
    let(:piece) { ChessPiece.new(position: Position.new('a1'), owner: white_player) }

    before do
      game_state.add_piece(piece)
    end

    it 'removes the piece' do
      game_state.remove_piece(piece)

      expect(game_state.pieces).to be_empty
    end
  end  

  describe '#pieces' do
    subject(:game_state) { described_class.new }

    before do
      allow(game_state).to receive(:black_player).and_return(black_player)
      allow(game_state).to receive(:white_player).and_return(black_player)

      game_state.add_piece(ChessPiece.new(position: Position.new('a1'), owner: white_player))
      game_state.add_piece(ChessPiece.new(position: Position.new('a2'), owner: black_player))
    end

    it 'returns all pieces' do
      actual = game_state.pieces.size

      expect(actual).to eq(2)
    end
  end

  describe '#player_pieces' do
    subject(:game_state) { described_class.new }

    before do
      game_state.add_piece(ChessPiece.new(position: Position.new('a1'), owner: white_player))
      game_state.add_piece(ChessPiece.new(position: Position.new('a2'), owner: black_player))
      game_state.add_piece(ChessPiece.new(position: Position.new('a3'), owner: black_player))
    end

    it 'returns only the specified player pieces' do  
      actual = game_state.player_pieces(white_player).size

      expect(actual).to eq(1)
    end
  end

  describe '#select_position' do
    subject(:game_state) { described_class.new }
    let(:position) { Position.new('a1') }
    let(:piece) { ChessPiece.new(position: position, owner: white_player) }

    before do
      game_state.add_piece(piece)
    end

    it 'selects the piece at position' do
      actual = game_state.select_position(position)

      expect(actual).to eq(piece)
    end
  end

  describe '#select_piece' do
    subject(:game_state) { described_class.new }
    let(:piece) { ChessPiece.new(position: Position.new('a1'), owner: white_player) }

    before do
      game_state.add_piece(piece)
    end

    it 'selects the piece' do
      actual = game_state.select_piece(piece)

      expect(actual).to eq(piece)
    end
  end

  describe '#occupied_at?' do
    subject(:game_state) { described_class.new }
    let(:position) { Position.new('a1') }
    let(:piece) { ChessPiece.new(position: position, owner: white_player) }

    before do
      game_state.add_piece(piece)
    end

    it 'returns true when occupied' do
      actual = game_state.occupied_at?(position)

      expect(actual).to be true
    end

    it 'returns false when not occupied' do
      empty_position = Position.new('h1')
      actual = game_state.occupied_at?(empty_position)

      expect(actual).to be false
    end
  end

  describe '#friendly_at?' do
    subject(:game_state) { described_class.new }
    let(:position) { Position.new('a1') }
    let(:piece) { ChessPiece.new(position: position, owner: white_player) }
    let(:enemy_position) { Position.new('a2') }
    let(:enemy_piece) { ChessPiece.new(position: enemy_position, owner: black_player) }

    before do
      game_state.add_piece(piece)
      game_state.add_piece(enemy_piece)
    end

    it 'returns true when friendly' do
      actual = game_state.friendly_at?(white_player, position)

      expect(actual).to be true
    end

    it 'returns false when not friendly' do
      actual = game_state.friendly_at?(white_player, enemy_position)
    end

    it 'returns false when no piece at position' do
      actual = game_state.friendly_at?(white_player, Position.new('c1'))
    end
  end

  describe '#enemy_at?' do
    subject(:game_state) { described_class.new }
    let(:position) { Position.new('a1') }
    let(:piece) { ChessPiece.new(position: position, owner: white_player) }
    let(:enemy_position) { Position.new('a2') }
    let(:enemy_piece) { ChessPiece.new(position: enemy_position, owner: black_player) }

    before do
      game_state.add_piece(piece)
      game_state.add_piece(enemy_piece)
    end

    it 'returns true when enemy' do
      actual = game_state.enemy_at?(white_player, enemy_position)

      expect(actual).to be true
    end

    it 'returns false when not enemy' do
      actual = game_state.enemy_at?(white_player, position)
    end

    it 'returns false when no piece at position' do
      actual = game_state.enemy_at?(white_player, Position.new('c1'))
    end
  end

  describe '#legal_moves' do
    subject(:game_state) { described_class.new(white: white_player, black: black_player) }

    before do
      game_state.add_piece(King.new(position: Position.new('a1'), owner: white_player))
      game_state.add_piece(Bishop.new(position: Position.new('a2'), owner: white_player))
      game_state.add_piece(Rook.new(position: Position.new('a4'), owner: black_player))
    end

    context 'when asking for white moves' do
      it 'returns the correct number of legal moves' do
        moves = game_state.legal_moves(white_player)

        expect(moves.size).to eq(2)
      end
    end

    context 'when asking for black moves' do
      it 'returns the correct number of legal moves' do
        moves = game_state.legal_moves(black_player)

        expect(moves.size).to eq(13)
      end
    end

    context 'when asking for invalid player' do
      it 'returns no legal moves' do
        moves = game_state.legal_moves(Object.new)

        expect(moves).to be_empty
      end
    end
  end

  describe '#under_threat?' do
    context 'when piece under threat' do
      subject(:game_state) { described_class.new(white: white_player, black: black_player) }
      let(:threatened_piece) { King.new(position: Position.new('a1'), owner: white_player) }

      before do
        game_state.add_piece(threatened_piece)
        game_state.add_piece(Rook.new(position: Position.new('a4'), owner: black_player))
      end

      it 'returns true' do
        actual = game_state.under_threat?(threatened_piece)

        expect(actual).to be true
      end
    end

    context 'when piece not under threat' do
      subject(:game_state) { described_class.new(white: white_player, black: black_player) }
      let(:not_threatened_piece) { King.new(position: Position.new('c3'), owner: white_player) }

      before do
        game_state.add_piece(not_threatened_piece)
        game_state.add_piece(Rook.new(position: Position.new('a4'), owner: black_player))
      end

      it 'returns true' do
        actual = game_state.under_threat?(not_threatened_piece)

        expect(actual).to be false
      end
    end
  end

  describe '#opposing_player' do
    subject(:game_state) { described_class.new(white: white_player, black: black_player) }
      
    it 'returns black for white' do
      actual = game_state.opposing_player(white_player)

      expect(actual).to eq(black_player)
    end

    it 'returns white for black' do
      actual = game_state.opposing_player(black_player)

      expect(actual).to eq(white_player)
    end
  end

  describe '#in_check?' do
    subject(:game_state) { described_class.new(white: white_player, black: black_player) }

    context 'when in check' do
      before do
        game_state.add_piece(King.new(position: Position.new('a1'), owner: white_player))
        game_state.add_piece(Rook.new(position: Position.new('a2'), owner: black_player))
      end

      it 'returns true' do
        actual = game_state.in_check?(white_player)

        expect(actual).to be true
      end
    end

    context 'when not in check' do
      before do
        game_state.add_piece(King.new(position: Position.new('a1'), owner: white_player))
        game_state.add_piece(Rook.new(position: Position.new('b2'), owner: black_player))
      end

      it 'returns false' do
        actual = game_state.in_check?(white_player)

        expect(actual).to be false
      end
    end
  end

  describe '#repetition_string' do
    subject(:game_state) { described_class.new(white: white_player, black: black_player) }

    before do
      game_state.add_piece(King.new(position: Position.new('a1'), owner: white_player))
      game_state.add_piece(Bishop.new(position: Position.new('a2'), owner: white_player))
      game_state.add_piece(Rook.new(position: Position.new('a4'), owner: black_player))
    end

    it 'returns string in the correct format' do
      actual = game_state.repetition_string
      expected = '8/8/8/8/r7/8/B7/K7 w KQkq -'

      expect(actual).to eq(expected)
    end
  end

  describe '#full_fen' do
    subject(:game_state) { described_class.new(white: white_player, black: black_player) }

    before do
      game_state.add_piece(King.new(position: Position.new('a1'), owner: white_player))
      game_state.add_piece(Bishop.new(position: Position.new('a2'), owner: white_player))
      game_state.add_piece(Rook.new(position: Position.new('a4'), owner: black_player))
    end

    it 'returns FEN string in the correct format' do
      actual = game_state.full_fen
      expected = '8/8/8/8/r7/8/B7/K7 w KQkq - 0 1'

      expect(actual).to eq(expected)
    end
  end
end
