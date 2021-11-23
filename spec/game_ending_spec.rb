require_relative '../lib/game_ending'
require_relative '../lib/game_state'

describe GameEnding do
  let(:white_player) { double('white_player', :name => 'white_player') }
  let(:black_player) { double('black_player', :name => 'black_player') }

  describe '#update' do
    context 'when checkmate' do
      subject(:checkmate_ending) { described_class.new }

      before do
        game_state = GameState.new(white: white_player, black: black_player)
        game_state.add_piece(King.new(position: Position.new('a1'), owner: white_player))
        game_state.add_piece(Rook.new(position: Position.new('e1'), owner: black_player))
        game_state.add_piece(Rook.new(position: Position.new('e2'), owner: black_player))

        checkmate_ending.update(game_state)
      end

      it 'sets the winner' do
        actual = checkmate_ending.winner
        expect(actual).to be(black_player)
      end

      it 'sets the correct ending message' do
        actual = checkmate_ending.message
        expected = "#{black_player.name} wins by checkmate!"

        expect(actual).to eq(expected)
      end

      it 'has an ending' do
        expect(checkmate_ending.ending?).to be true
      end
    end

    context 'when stalemate' do
      subject(:stalemate_ending) { described_class.new }

      before do
        game_state = GameState.new(white: white_player, black: black_player)
        game_state.add_piece(King.new(position: Position.new('b1'), owner: white_player))
        game_state.add_piece(Rook.new(position: Position.new('a2'), owner: black_player))
        game_state.add_piece(Rook.new(position: Position.new('c2'), owner: black_player))

        stalemate_ending.update(game_state)
      end

      it 'does not set a winner' do
        expect(stalemate_ending.winner).to be_nil
      end

      it 'sets the correct ending message' do
        actual = stalemate_ending.message
        expected = 'Stalemate!'

        expect(actual).to eq(expected)
      end

      it 'has an ending' do
        expect(stalemate_ending.ending?).to be true
      end
    end

    context 'when 75 move rule' do
      subject(:half_move_ending) { described_class.new }

      before do
        game_state = GameState.new(white: white_player, black: black_player)
        game_state.add_piece(King.new(position: Position.new('e1'), owner: white_player))
        game_state.add_piece(King.new(position: Position.new('e8'), owner: black_player))
        game_state.add_piece(Rook.new(position: Position.new('c2'), owner: black_player))

        allow(game_state).to receive(:half_move_clock).and_return(75)
        half_move_ending.update(game_state)
      end

      it 'does not set a winner' do
        expect(half_move_ending.winner).to be_nil
      end

      it 'sets the correct ending message' do
        actual = half_move_ending.message
        expected = 'Draw by 75 move rule'

        expect(actual).to eq(expected)
      end

      it 'has an ending' do
        expect(half_move_ending.ending?).to be true
      end
    end

    context 'when 5 fold repetition' do
      subject(:five_fold_ending) { described_class.new }

      before do
        game_state = GameState.new(white: white_player, black: black_player)
        game_state.add_piece(King.new(position: Position.new('e1'), owner: white_player))
        game_state.add_piece(King.new(position: Position.new('e8'), owner: black_player))
        game_state.add_piece(Rook.new(position: Position.new('c2'), owner: black_player))

        allow(game_state).to receive(:repetitions).and_return(5)
        five_fold_ending.update(game_state)
      end

      it 'does not set a winner' do
        expect(five_fold_ending.winner).to be_nil
      end

      it 'sets the correct ending message' do
        actual = five_fold_ending.message
        expected = 'Draw by five-fold repetition'

        expect(actual).to eq(expected)
      end

      it 'has an ending' do
        expect(five_fold_ending.ending?).to be true
      end
    end

    context 'when dead position' do
      context 'when king vs king' do
        subject(:dead_position) { described_class.new }

        before do
          game_state = GameState.new(white: white_player, black: black_player)
          game_state.add_piece(King.new(position: Position.new('e1'), owner: white_player))
          game_state.add_piece(King.new(position: Position.new('e8'), owner: black_player))
  
          dead_position.update(game_state)
        end
  
        it 'does not set a winner' do
          expect(dead_position.winner).to be_nil
        end
  
        it 'sets the correct ending message' do
          actual = dead_position.message
          expected = 'Draw due to dead position (K vs. K)'
  
          expect(actual).to eq(expected)
        end
  
        it 'has an ending' do
          expect(dead_position.ending?).to be true
        end
      end
  
      context 'when king vs king knight' do
        subject(:dead_position) { described_class.new }

        before do
          game_state = GameState.new(white: white_player, black: black_player)
          game_state.add_piece(King.new(position: Position.new('e1'), owner: white_player))
          game_state.add_piece(Knight.new(position: Position.new('e2'), owner: white_player))
          game_state.add_piece(King.new(position: Position.new('e8'), owner: black_player))
  
          dead_position.update(game_state)
        end
  
        it 'does not set a winner' do
          expect(dead_position.winner).to be_nil
        end
  
        it 'sets the correct ending message' do
          actual = dead_position.message
          expected = 'Draw due to dead position (K vs. KN)'
  
          expect(actual).to eq(expected)
        end
  
        it 'has an ending' do
          expect(dead_position.ending?).to be true
        end
      end

      context 'when king vs king bishop' do
        subject(:dead_position) { described_class.new }

        before do
          game_state = GameState.new(white: white_player, black: black_player)
          game_state.add_piece(King.new(position: Position.new('e1'), owner: white_player))
          game_state.add_piece(Bishop.new(position: Position.new('e2'), owner: white_player))
          game_state.add_piece(King.new(position: Position.new('e8'), owner: black_player))
  
          dead_position.update(game_state)
        end
  
        it 'does not set a winner' do
          expect(dead_position.winner).to be_nil
        end
  
        it 'sets the correct ending message' do
          actual = dead_position.message
          expected = 'Draw due to dead position (K vs. KB)'
  
          expect(actual).to eq(expected)
        end
  
        it 'has an ending' do
          expect(dead_position.ending?).to be true
        end
      end

      context 'when king bishop vs king bishop (bishops on same color)' do
        subject(:dead_position) { described_class.new }

        before do
          game_state = GameState.new(white: white_player, black: black_player)
          game_state.add_piece(King.new(position: Position.new('e1'), owner: white_player))
          game_state.add_piece(Bishop.new(position: Position.new('e2'), owner: white_player))
          game_state.add_piece(King.new(position: Position.new('e8'), owner: black_player))
          game_state.add_piece(Bishop.new(position: Position.new('e6'), owner: black_player))
  
          dead_position.update(game_state)
        end
  
        it 'does not set a winner' do
          expect(dead_position.winner).to be_nil
        end
  
        it 'sets the correct ending message' do
          actual = dead_position.message
          expected = 'Draw due to dead position (KB vs. KB, same color B)'
  
          expect(actual).to eq(expected)
        end
  
        it 'has an ending' do
          expect(dead_position.ending?).to be true
        end
      end
    end

    context 'when no ending detected' do
      subject(:no_ending) { described_class.new }

      before do
        game_state = GameState.new(white: white_player, black: black_player)
        game_state.add_piece(King.new(position: Position.new('a8'), owner: white_player))
        game_state.add_piece(Rook.new(position: Position.new('e1'), owner: black_player))
        game_state.add_piece(Rook.new(position: Position.new('e2'), owner: black_player))

        no_ending.update(game_state)
      end

      it 'does not set a winner' do
        expect(no_ending.winner).to be_nil
      end

      it 'does not set a message' do
        expect(no_ending.message).to be_nil
      end

      it 'has an ending' do
        expect(no_ending.ending?).to be false
      end
    end
  end
end
