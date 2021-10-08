# frozen_string_literal: true

require_relative '../../lib/pieces/white_pawn'
require_relative '../../lib/game_state'
require_relative 'shared/default_castling'
require_relative 'shared/default_castling_partner'
require_relative 'shared/default_check'
require_relative 'shared/default_en_passant'
require_relative 'shared/piece_custom_matchers'

describe WhitePawn do
  subject(:white_pawn) { described_class.new(position: Position.new('c4')) }

  context '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        Offset.new([-1, 1]),
        Offset.new([1, 1])
      ]

      actual = white_pawn.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  context '#movement_offsets' do
    context 'when on rank 2' do
      subject(:white_pawn_on_rank_2) { described_class.new(position: Position.new('a2')) }

      it 'has the correct move offsets' do
        expected = [RepeatOffset.new([0, 1], 2)]
  
        actual = white_pawn_on_rank_2.move_offsets
  
        expect(actual).to eq(expected)
      end
    end

    context 'when not on rank 2' do
      subject(:white_pawn_on_rank_3) { described_class.new(position: Position.new('a3')) }
      
      it 'has the correct move offsets' do
        expected = [Offset.new([0, 1])]
  
        actual = white_pawn_on_rank_3.move_offsets
  
        expect(actual).to eq(expected)
      end
    end
  end

  describe "#notation_letter" do
    it 'returns P' do
      actual = white_pawn.notation_letter
      expect(actual).to eq('P')
    end
  end
  
  context "when #{described_class.name} implements default behaviors" do
    include_examples 'default castling behavior'
    include_examples 'default castling partner behavior'
    include_examples 'default check behavior'
  end

  # context "when #{described_class.name} has special behavior" do
  #   context '#en_passant?' do
  #     it 'returns true' do
  #       expect(white_pawn).to be_en_passant?
  #     end
  #   end
  # end

  describe "#actions" do
    context 'when on a2' do
      white_pawn_position = Position.new('a2')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      white_pawn_at_a2 = described_class.new(position: white_pawn_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new([white_pawn_at_a2])
          @white_pawn_actions = white_pawn_at_a2.actions(@game_state)
        end
        
        it 'has 2 possible moves' do
          actual = @white_pawn_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(2)
        end

        it 'can move to a3' do
          expect(@white_pawn_actions).to be_available_move(Position.new('a3'))
        end

        it 'can move to a4' do
          expect(@white_pawn_actions).to be_available_move(Position.new('a4'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['a4']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([white_pawn_at_a2])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @white_pawn_actions = white_pawn_at_a2.actions(@game_state)
          end

          it 'has 1 possible move' do
            actual = @white_pawn_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(1)
          end

          it 'can move to a3' do
            expect(@white_pawn_actions).to be_available_move(Position.new('a3'))
          end
        end
      end

      context 'when move blocked by enemy pieces' do
        enemy_positions = ['a4']

        context "when enemy at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([white_pawn_at_a2])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @white_pawn_actions = white_pawn_at_a2.actions(@game_state)
          end

          it 'has 1 possible move' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(1)
          end

          it 'can move to a3' do
            expect(@white_pawn_actions).to be_available_move(Position.new('a3'))
          end

          it 'has 0 possible captures' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(0)
          end
        end
      end

      context 'when enemies in capture range' do
        enemy_positions = ['a4']

        context "when enemy at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([white_pawn_at_a2])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @white_pawn_actions = white_pawn_at_a2.actions(@game_state)
          end

          it 'has 1 possible move' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(1)
          end

          it 'can move to a3' do
            expect(@white_pawn_actions).to be_available_move(Position.new('a3'))
          end

          it 'has 0 possible captures' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(0)
          end
        end
      end
    end

    context 'when on b3' do
      white_pawn_position = Position.new('b3')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      white_pawn_at_b3 = described_class.new(position: white_pawn_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new([white_pawn_at_b3])
          @white_pawn_actions = white_pawn_at_b3.actions(@game_state)
        end
        
        it 'has 1 possible move' do
          actual = @white_pawn_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(1)
        end

        it 'can move to b4' do
          expect(@white_pawn_actions).to be_available_move(Position.new('b4'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['b4']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([white_pawn_at_b3])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @white_pawn_actions = white_pawn_at_b3.actions(@game_state)
          end

          it 'has 0 possible moves' do
            actual = @white_pawn_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(0)
          end
        end
      end

      context 'when move blocked by enemy pieces' do
        enemy_positions = ['b4']

        context "when enemy at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([white_pawn_at_b3])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @white_pawn_actions = white_pawn_at_b3.actions(@game_state)
          end

          it 'has 0 possible moves' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(0)
          end

          it 'has 0 possible captures' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(0)
          end
        end
      end

      context 'when enemies on all 4 diagonals' do
        enemy_positions = ['a2', 'a4', 'c2', 'c4']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([white_pawn_at_b3])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @white_pawn_actions = white_pawn_at_b3.actions(@game_state)
          end

          it 'has 1 possible moves' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(1)
          end

          it 'can move to b4' do
            expect(@white_pawn_actions).to be_available_move(Position.new('b4'))
          end

          it 'has 2 possible captures' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(2)
          end

          it 'can capture a4' do
            expect(@white_pawn_actions).to be_available_capture(Position.new('a4'))
          end

          it 'can capture c4' do
            expect(@white_pawn_actions).to be_available_capture(Position.new('c4'))
          end
        end
      end
    end

    context 'when on b7' do
      white_pawn_position = Position.new('b7')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      white_pawn_at_b7 = described_class.new(position: white_pawn_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new([white_pawn_at_b7])
          @white_pawn_actions = white_pawn_at_b7.actions(@game_state)
        end
        
        it 'has 0 possible moves' do
          actual = @white_pawn_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(0)
        end

        it 'has 1 possible promote' do
          actual = @white_pawn_actions.select { |action| action.is_a? Promote}.size
          expect(actual).to eq(1)
        end

        it 'can promote at b8' do
          expect(@white_pawn_actions).to be_available_promote(Position.new('b8'))
        end
      end

      context 'when enemies on rank 8 diagonals' do
        enemy_positions = ['a8', 'c8']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([white_pawn_at_b7])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @white_pawn_actions = white_pawn_at_b7.actions(@game_state)
          end

          it 'has 0 possible moves' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(0)
          end

          it 'has 0 possible captures' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(0)
          end

          it 'has 1 possible promotes' do
            actual = @white_pawn_actions.select { |action| action.is_a?(Promote)}.size
            expect(actual).to eq(1)
          end

          it 'can promote at b8' do
            expect(@white_pawn_actions).to be_available_promote(Position.new('b8'))
          end

          it 'has 2 possible promote captures' do
            actual = @white_pawn_actions.select { |action| action.is_a?(PromoteCapture)}.size
            expect(actual).to eq(2)
          end

          it 'can promote capture to a8' do
            expect(@white_pawn_actions).to be_available_promote_capture(Position.new('a8'))
          end

          it 'can promote capture to c8' do
            expect(@white_pawn_actions).to be_available_promote_capture(Position.new('c8'))
          end
        end
      end
    end
  end
end

