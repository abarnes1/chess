# frozen_string_literal: true

require_relative '../../lib/pieces/black_pawn'
require_relative '../../lib/game_state'
require_relative 'shared/piece_custom_matchers'

describe BlackPawn do
  subject(:black_pawn) { described_class.new(position: Position.new('c4')) }

  context '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        Offset.new([-1, -1]), 
        Offset.new([1, -1])
      ]

      actual = black_pawn.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  context '#movement_offsets' do
    context 'when on rank 7' do
      subject(:black_pawn_on_rank_7) { described_class.new(position: Position.new('a2')) }

      it 'has the correct move offsets' do
        expected = [RepeatOffset.new([0, -1], 2)]
  
        actual = black_pawn_on_rank_7.move_offsets
  
        expect(actual).to eq(expected)
      end
    end

    context 'when not on rank 7' do
      subject(:black_pawn_on_rank_6) { described_class.new(position: Position.new('a3')) }
      
      it 'has the correct move offsets' do
        expected = [Offset.new([0, -1])]
  
        actual = black_pawn_on_rank_6.move_offsets
  
        expect(actual).to eq(expected)
      end
    end
  end

  describe "#notation_letter" do
    it 'returns P' do
      actual = black_pawn.notation_letter
      expect(actual).to eq('P')
    end
  end

  describe "#actions" do
    context 'when on b7' do
      black_pawn_position = Position.new('b7')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      black_pawn_at_b7 = described_class.new(position: black_pawn_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new(pieces: [black_pawn_at_b7])
          @black_pawn_actions = black_pawn_at_b7.actions(@game_state)
        end
        
        it 'has 2 possible moves' do
          actual = @black_pawn_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(2)
        end

        it 'can move to b6' do
          expect(@black_pawn_actions).to be_available_move(Position.new('b6'))
        end

        it 'can move to b5' do
          expect(@black_pawn_actions).to be_available_move(Position.new('b5'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['b5']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [black_pawn_at_b7])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @black_pawn_actions = black_pawn_at_b7.actions(@game_state)
          end

          it 'has 1 possible move' do
            actual = @black_pawn_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(1)
          end

          it 'can move to b6' do
            expect(@black_pawn_actions).to be_available_move(Position.new('b6'))
          end
        end
      end

      context 'when move blocked by enemy pieces' do
        enemy_positions = ['b5']

        context "when enemy at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [black_pawn_at_b7])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @black_pawn_actions = black_pawn_at_b7.actions(@game_state)
          end

          it 'has 1 possible move' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(1)
          end

          it 'can move to b6' do
            expect(@black_pawn_actions).to be_available_move(Position.new('b6'))
          end

          it 'has 0 possible captures' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(0)
          end
        end
      end
    end

    context 'when on b6' do
      black_pawn_position = Position.new('b6')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      black_pawn_at_b6 = described_class.new(position: black_pawn_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new(pieces: [black_pawn_at_b6])
          @black_pawn_actions = black_pawn_at_b6.actions(@game_state)
        end
        
        it 'has 1 possible move' do
          actual = @black_pawn_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(1)
        end

        it 'can move to b5' do
          expect(@black_pawn_actions).to be_available_move(Position.new('b5'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['b5']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [black_pawn_at_b6])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @black_pawn_actions = black_pawn_at_b6.actions(@game_state)
          end

          it 'has 0 possible moves' do
            actual = @black_pawn_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(0)
          end
        end
      end

      context 'when move blocked by enemy pieces' do
        enemy_positions = ['b5']

        context "when enemy at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [black_pawn_at_b6])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @black_pawn_actions = black_pawn_at_b6.actions(@game_state)
          end

          it 'has 0 possible moves' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(0)
          end

          it 'has 0 possible captures' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(0)
          end
        end
      end

      context 'when enemies on all 4 diagonals' do
        enemy_positions = ['a5', 'a7', 'c5', 'c7']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [black_pawn_at_b6])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @black_pawn_actions = black_pawn_at_b6.actions(@game_state)
          end

          it 'has 1 possible moves' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(1)
          end

          it 'can move to b5' do
            expect(@black_pawn_actions).to be_available_move(Position.new('b5'))
          end

          it 'has 2 possible captures' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(2)
          end

          it 'can capture a5' do
            expect(@black_pawn_actions).to be_available_capture(Position.new('a5'))
          end

          it 'can capture c5' do
            expect(@black_pawn_actions).to be_available_capture(Position.new('c5'))
          end
        end
      end
    end

    context 'when on b2' do
      black_pawn_position = Position.new('b2')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      black_pawn_at_b2 = described_class.new(position: black_pawn_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new(pieces: [black_pawn_at_b2])
          @black_pawn_actions = black_pawn_at_b2.actions(@game_state)
        end
        
        it 'has 0 possible moves' do
          actual = @black_pawn_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(0)
        end

        it 'has 1 possible promote' do
          actual = @black_pawn_actions.select { |action| action.is_a? Promote}.size
          expect(actual).to eq(1)
        end

        it 'can promote at b1' do
          expect(@black_pawn_actions).to be_available_promote(Position.new('b1'))
        end
      end

      context 'when enemies on rank 1 diagonals' do
        enemy_positions = ['a1', 'c1']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [black_pawn_at_b2])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @black_pawn_actions = black_pawn_at_b2.actions(@game_state)
          end

          it 'has 0 possible moves' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(0)
          end

          it 'has 0 possible captures' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(0)
          end

          it 'has 1 possible promotes' do
            actual = @black_pawn_actions.select { |action| action.is_a?(Promote)}.size
            expect(actual).to eq(1)
          end

          it 'can promote at b1' do
            expect(@black_pawn_actions).to be_available_promote(Position.new('b1'))
          end

          it 'has 2 possible promote captures' do
            actual = @black_pawn_actions.select { |action| action.is_a?(PromoteCapture)}.size
            expect(actual).to eq(2)
          end

          it 'can promote capture to a1' do
            expect(@black_pawn_actions).to be_available_promote_capture(Position.new('a1'))
          end

          it 'can promote capture to c1' do
            expect(@black_pawn_actions).to be_available_promote_capture(Position.new('c1'))
          end
        end
      end
    end

    context 'when on b4' do
      black_pawn_position = Position.new('b4')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      black_pawn_at_b4 = described_class.new(position: black_pawn_position, owner: friendly_owner)

      context "when enemy pawn moves two squares: a2 to a4" do
        enemy_pawn_position = Position.new('a2')

        before(:all) do
          @game_state = GameState.new(pieces: [black_pawn_at_b4])
          @enemy_pawn = WhitePawn.new(position: enemy_pawn_position, owner: enemy_owner)
          @game_state.add_piece(@enemy_pawn)
          @enemy_pawn_move = Move.new(@enemy_pawn, @enemy_pawn.position, Position.new('a4'))
          @game_state.apply_action(@enemy_pawn_move)

          @black_pawn_actions = black_pawn_at_b4.actions(@game_state)
        end

        it 'has 1 en passant action' do
          actual = @black_pawn_actions.select { |action| action.is_a?(EnPassant)}.size
          expect(actual).to eq(1)
        end

        it 'can en passant to a3'  do
          expect(@black_pawn_actions).to be_available_en_passant(Position.new('a3'))
        end
      end

      context "when enemy pawn moves two squares: c2 to c4" do
        enemy_pawn_position = Position.new('c2')

        before(:all) do
          @game_state = GameState.new(pieces: [black_pawn_at_b4])
          @enemy_pawn = WhitePawn.new(position: enemy_pawn_position, owner: enemy_owner)
          @game_state.add_piece(@enemy_pawn)
          @enemy_pawn_move = Move.new(@enemy_pawn, @enemy_pawn.position, Position.new('c4'))
          @game_state.apply_action(@enemy_pawn_move)

          @black_pawn_actions = black_pawn_at_b4.actions(@game_state)
        end

        it 'has 1 en passant action' do
          actual = @black_pawn_actions.select { |action| action.is_a?(EnPassant)}.size
          expect(actual).to eq(1)
        end

        it 'can en passant to c3'  do
          expect(@black_pawn_actions).to be_available_en_passant(Position.new('c3'))
        end
      end
    end
  end
end
