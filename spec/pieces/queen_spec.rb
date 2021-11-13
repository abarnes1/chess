# frozen_string_literal: true

require_relative '../../lib/pieces/queen'
require_relative '../../lib/game_state'
require_relative 'shared/piece_custom_matchers'

describe Queen do
  subject(:queen) { described_class.new(position: Position.new('c4')) }

  describe '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1]),
        RepeatOffset.new([1, 0]),
        RepeatOffset.new([-1, 0]),
        RepeatOffset.new([0, 1]),
        RepeatOffset.new([0, -1])
      ]

      actual = queen.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  describe '#movement_offsets' do
    it 'has the correct movement offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1]),
        RepeatOffset.new([1, 0]),
        RepeatOffset.new([-1, 0]),
        RepeatOffset.new([0, 1]),
        RepeatOffset.new([0, -1])
      ]

      actual = queen.move_offsets

      expect(actual).to eq(expected)
    end
  end

  describe "#notation_letter" do
    it 'returns Q' do
      actual = queen.notation_letter
      expect(actual).to eq('Q')
    end
  end

  describe "#actions" do
    context 'when on c4' do
      queen_position = Position.new('c4')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      queen_at_c4 = described_class.new(position: queen_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new(pieces: [queen_at_c4])
          @queen_actions = queen_at_c4.actions(@game_state)
        end
        
        it 'has 25 possible moves' do
          actual = @queen_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(25)
        end
        
        it 'can move to d4' do
          expect(@queen_actions).to be_available_move(Position.new('d4'))
        end

        it 'can move to e4' do
          expect(@queen_actions).to be_available_move(Position.new('e4'))
        end

        it 'can move to f4' do
          expect(@queen_actions).to be_available_move(Position.new('f4'))
        end

        it 'can move to g4' do
          expect(@queen_actions).to be_available_move(Position.new('g4'))
        end

        it 'can move to h4' do
          expect(@queen_actions).to be_available_move(Position.new('h4'))
        end

        it 'can move to d3' do
          expect(@queen_actions).to be_available_move(Position.new('d3'))
        end

        it 'can move to e2' do
          expect(@queen_actions).to be_available_move(Position.new('e2'))
        end

        it 'can move to f1' do
          expect(@queen_actions).to be_available_move(Position.new('f1'))
        end

        it 'can move to c3' do
          expect(@queen_actions).to be_available_move(Position.new('c3'))
        end

        it 'can move to c2' do
          expect(@queen_actions).to be_available_move(Position.new('c2'))
        end

        it 'can move to c1' do
          expect(@queen_actions).to be_available_move(Position.new('c1'))
        end

        it 'can move to b3' do
          expect(@queen_actions).to be_available_move(Position.new('b3'))
        end

        it 'can move to a2' do
          expect(@queen_actions).to be_available_move(Position.new('a2'))
        end

        it 'can move to b4' do
          expect(@queen_actions).to be_available_move(Position.new('b4'))
        end

        it 'can move to a4' do
          expect(@queen_actions).to be_available_move(Position.new('a4'))
        end

        it 'can move to b5' do
          expect(@queen_actions).to be_available_move(Position.new('b5'))
        end

        it 'can move to a6' do
          expect(@queen_actions).to be_available_move(Position.new('a6'))
        end

        it 'can move to c5' do
          expect(@queen_actions).to be_available_move(Position.new('c5'))
        end

        it 'can move to c6' do
          expect(@queen_actions).to be_available_move(Position.new('c6'))
        end

        it 'can move to c7' do
          expect(@queen_actions).to be_available_move(Position.new('c7'))
        end

        it 'can move to c8' do
          expect(@queen_actions).to be_available_move(Position.new('c8'))
        end

        it 'can move to d5' do
          expect(@queen_actions).to be_available_move(Position.new('d5'))
        end

        it 'can move to e6' do
          expect(@queen_actions).to be_available_move(Position.new('e6'))
        end

        it 'can move to f7' do
          expect(@queen_actions).to be_available_move(Position.new('f7'))
        end

        it 'can move to g8' do
          expect(@queen_actions).to be_available_move(Position.new('g8'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['c5', 'd5', 'd4', 'c3']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [queen_at_c4])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @queen_actions = queen_at_c4.actions(@game_state)
          end

          it 'has 9 possible moves' do
            actual = @queen_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(9)
          end

          it 'can move to d3' do
            expect(@queen_actions).to be_available_move(Position.new('d3'))
          end

          it 'can move to e2' do
            expect(@queen_actions).to be_available_move(Position.new('e2'))
          end

          it 'can move to f1' do
            expect(@queen_actions).to be_available_move(Position.new('f1'))
          end

          it 'can move to b3' do
            expect(@queen_actions).to be_available_move(Position.new('b3'))
          end

          it 'can move to a2' do
            expect(@queen_actions).to be_available_move(Position.new('a2'))
          end

          it 'can move to b4' do
            expect(@queen_actions).to be_available_move(Position.new('b4'))
          end

          it 'can move to a4' do
            expect(@queen_actions).to be_available_move(Position.new('a4'))
          end

          it 'can move to b5' do
            expect(@queen_actions).to be_available_move(Position.new('b5'))
          end
          
          it 'can move to a6' do
            expect(@queen_actions).to be_available_move(Position.new('a6'))
          end
        end
      end

      context 'when blocked by enemy pieces' do
        enemy_positions = ['b3', 'b4', 'b5', 'c3', 'd3', 'd4', 'f7']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [queen_at_c4])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @queen_actions = queen_at_c4.actions(@game_state)
          end

          it 'has 6 possible moves' do
            actual = @queen_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(6)
          end

          it 'can move to c5' do
            expect(@queen_actions).to be_available_move(Position.new('c5'))
          end

          it 'can move to c6' do
            expect(@queen_actions).to be_available_move(Position.new('c6'))
          end

          it 'can move to c7' do
            expect(@queen_actions).to be_available_move(Position.new('c7'))
          end

          it 'can move to c8' do
            expect(@queen_actions).to be_available_move(Position.new('c8'))
          end

          it 'can move to d5' do
            expect(@queen_actions).to be_available_move(Position.new('d5'))
          end

          it 'can move to e6' do
            expect(@queen_actions).to be_available_move(Position.new('e6'))
          end

          it 'has 7 possible captures' do
            actual = @queen_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(7)
          end

          it 'can capture d4' do
            expect(@queen_actions).to be_available_capture(Position.new('d4'))
          end

          it 'can capture d3' do
            expect(@queen_actions).to be_available_capture(Position.new('d3'))
          end

          it 'can capture c3' do
            expect(@queen_actions).to be_available_capture(Position.new('c3'))
          end

          it 'can capture b3' do
            expect(@queen_actions).to be_available_capture(Position.new('b3'))
          end

          it 'can capture b4' do
            expect(@queen_actions).to be_available_capture(Position.new('b4'))
          end

          it 'can capture b5' do
            expect(@queen_actions).to be_available_capture(Position.new('b5'))
          end

          it 'can capture f7' do
            expect(@queen_actions).to be_available_capture(Position.new('f7'))
          end
        end
      end
    end
  end
end
