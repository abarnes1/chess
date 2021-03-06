# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/game_state'
require_relative 'shared/piece_custom_matchers'

describe King do
  subject(:king) { described_class.new(position: Position.new('c4')) }

  describe '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        Offset.new([-1, -1]),
        Offset.new([-1, 1]),
        Offset.new([-1, 0]),
        Offset.new([1, 0]),
        Offset.new([1, -1]),
        Offset.new([1, 1]),
        Offset.new([0, -1]),
        Offset.new([0, 1])
      ]

      actual = king.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  describe '#movement_offsets' do
    it 'has the correct movement offsets' do
      expected = [
        Offset.new([-1, -1]),
        Offset.new([-1, 1]),
        Offset.new([-1, 0]),
        Offset.new([1, 0]),
        Offset.new([1, -1]),
        Offset.new([1, 1]),
        Offset.new([0, -1]),
        Offset.new([0, 1])
      ]

      actual = king.move_offsets

      expect(actual).to eq(expected)
    end
  end

  describe "#notation_letter" do
    it 'returns K' do
      actual = king.notation_letter
      expect(actual).to eq('K')
    end
  end

  describe "#actions" do
    context 'when on c4' do
      king_position = Position.new('c4')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      king_at_c4 = described_class.new(position: king_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new(pieces: [king_at_c4])
          @king_actions = king_at_c4.actions(@game_state)
        end
        
        it 'has 8 possible moves' do
          actual = @king_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(8)
        end

        it 'can move to b3' do
          expect(@king_actions).to be_available_move(Position.new('b3'))
        end

        it 'can move to b4' do
          expect(@king_actions).to be_available_move(Position.new('b4'))
        end

        it 'can move to b5' do
          expect(@king_actions).to be_available_move(Position.new('b5'))
        end

        it 'can move to c3' do
          expect(@king_actions).to be_available_move(Position.new('c3'))
        end

        it 'can move to c5' do
          expect(@king_actions).to be_available_move(Position.new('c5'))
        end

        it 'can move to d3' do
          expect(@king_actions).to be_available_move(Position.new('d3'))
        end

        it 'can move to d4' do
          expect(@king_actions).to be_available_move(Position.new('d4'))
        end

        it 'can move to d5' do
          expect(@king_actions).to be_available_move(Position.new('d5'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['b3', 'b4', 'b5', 'c5']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [king_at_c4])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @king_actions = king_at_c4.actions(@game_state)
          end

          it 'has 4 possible moves' do
            actual = @king_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(4)
          end

          it 'can move to c3' do
            expect(@king_actions).to be_available_move(Position.new('c3'))
          end

          it 'can move to d3' do
            expect(@king_actions).to be_available_move(Position.new('d3'))
          end

          it 'can move to d4' do
            expect(@king_actions).to be_available_move(Position.new('d4'))
          end

          it 'can move to d5' do
            expect(@king_actions).to be_available_move(Position.new('d5'))
          end
        end
      end

      context 'when blocked by enemy pieces' do
        enemy_positions = ['c3', 'd3', 'd4', 'd5']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [king_at_c4])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @king_actions = king_at_c4.actions(@game_state)
          end

          it 'has 4 possible moves' do
            actual = @king_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(4)
          end

          it 'can move to b3' do
            expect(@king_actions).to be_available_move(Position.new('b3'))
          end

          it 'can move to b4' do
            expect(@king_actions).to be_available_move(Position.new('b4'))
          end

          it 'can move to b5' do
            expect(@king_actions).to be_available_move(Position.new('b5'))
          end

          it 'can move to c5' do
            expect(@king_actions).to be_available_move(Position.new('c5'))
          end


          it 'has 4 possible captures' do
            actual = @king_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(4)
          end

          it 'can capture c3' do
            expect(@king_actions).to be_available_capture(Position.new('c3'))
          end

          it 'can capture d3' do
            expect(@king_actions).to be_available_capture(Position.new('d3'))
          end

          it 'can capture d4' do
            expect(@king_actions).to be_available_capture(Position.new('d4'))
          end

          it 'can capture d5' do
            expect(@king_actions).to be_available_capture(Position.new('d5'))
          end
        end
      end
    end

    context 'when on e1' do
      context 'when white player' do
        king_position = Position.new('e1')
        friendly_owner = 'player1'
        enemy_owner = 'player2'
        king_at_e1 = described_class.new(position: king_position, owner: friendly_owner)

        partner_positions = ['a1', 'h1']

        context "when rooks partners at #{partner_positions.join(', ')}" do
          context 'when no enemy pieces' do
            before(:all) do
              @game_state = GameState.new(pieces: [king_at_e1], white: friendly_owner)

              partner_positions.each do |position|
                @game_state.add_piece(Rook.new(position: Position.new(position), owner: friendly_owner))
              end

              @king_actions = king_at_e1.actions(@game_state)
            end

            it 'has 2 possible castling actions' do
              actual = @king_actions.select { |action| action.is_a?(Castling)}.size
              expect(actual).to eq(2)
            end

            it 'can castle to c1' do
              expect(@king_actions).to be_available_castling(Position.new('c1'))
            end

            it 'can castle to g1' do
              expect(@king_actions).to be_available_castling(Position.new('g1'))
            end
          end
        end

        context 'when castling path is attackable' do
          let(:white_player) { 'white_player' }
          let(:black_player) { 'black_player' }
          let(:game_state) { GameState.new(white: white_player, black: black_player) }

          let(:rook) { Rook.new(position: Position.new('h1'), owner: white_player) }
          subject(:king) { described_class.new(position: Position.new('e1'), owner: white_player) }

          before do
            game_state.add_piece(rook)
            game_state.add_piece(king)

            game_state.add_piece(Rook.new(position: Position.new('f3'), owner: black_player))
          end

          it 'has no castling actions' do
            king_actions = king.actions(game_state)
            actual = king_actions.select{ |action| action.instance_of?(Castling)}.size

            expect(actual).to eq(0)
          end
        end
      end

      context 'when black player' do
        king_position = Position.new('e1')
        friendly_owner = 'player1'
        enemy_owner = 'player2'
        king_at_e1 = described_class.new(position: king_position, owner: friendly_owner)

        partner_positions = ['a1', 'h1']

        context "when friendly rooks at #{partner_positions.join(', ')}" do
          context 'when no enemy pieces' do
            before(:all) do
              @game_state = GameState.new(pieces: [king_at_e1], black: friendly_owner)

              partner_positions.each do |position|
                @game_state.add_piece(Rook.new(position: Position.new(position), owner: friendly_owner))
              end

              @king_actions = king_at_e1.actions(@game_state)
            end

            it 'has 0 possible castling actions' do
              actual = @king_actions.select { |action| action.is_a?(Castling)}.size
              expect(actual).to eq(0)
            end
          end
        end
      end
    end

    context 'when on e8' do
      context 'when white player' do
        king_position = Position.new('e8')
        friendly_owner = 'player1'
        enemy_owner = 'player2'
        king_at_e8 = described_class.new(position: king_position, owner: friendly_owner)

        partner_positions = ['a8', 'h8']

        context "when friendly rooks at #{partner_positions.join(', ')}" do
          context 'when no enemy pieces' do
            before(:all) do
              @game_state = GameState.new(pieces: [king_at_e8], white: friendly_owner)

              partner_positions.each do |position|
                @game_state.add_piece(Rook.new(position: Position.new(position), owner: friendly_owner))
              end

              @king_actions = king_at_e8.actions(@game_state)
            end

            it 'has 0 possible castling actions' do
              actual = @king_actions.select { |action| action.is_a?(Castling)}.size
              expect(actual).to eq(0)
            end
          end
        end
      end
      
      context 'when black player' do
        king_position = Position.new('e8')
        friendly_owner = 'player1'
        enemy_owner = 'player2'
        king_at_e8 = described_class.new(position: king_position, owner: friendly_owner)

        partner_positions = ['a8', 'h8']

        context "when castling partners at #{partner_positions.join(', ')}" do
          context 'when no enemy pieces' do
            before(:all) do
              @game_state = GameState.new(pieces: [king_at_e8], black: friendly_owner)

              partner_positions.each do |position|
                @game_state.add_piece(Rook.new(position: Position.new(position), owner: friendly_owner))
              end

              @king_actions = king_at_e8.actions(@game_state)
            end

            it 'has 2 possible castling actions' do
              actual = @king_actions.select { |action| action.is_a?(Castling)}.size
              expect(actual).to eq(2)
            end

            it 'can castle to c8' do
              expect(@king_actions).to be_available_castling(Position.new('c8'))
            end

            it 'can castle to g8' do
              expect(@king_actions).to be_available_castling(Position.new('g8'))
            end
          end
        end
      end
    end
  end
end
