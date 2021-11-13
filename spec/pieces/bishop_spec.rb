# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative '../../lib/game_state'
require_relative 'shared/piece_custom_matchers'

describe Bishop do
  subject(:bishop) { described_class.new(position: Position.new('c4')) }

  describe '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1])
      ]

      actual = bishop.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  describe '#movement_offsets' do
    it 'has the correct movement offsets' do
      expected = [
        RepeatOffset.new([-1, -1]),
        RepeatOffset.new([-1,  1]),
        RepeatOffset.new([1, -1]),
        RepeatOffset.new([1,  1])
      ]

      actual = bishop.move_offsets

      expect(actual).to eq(expected)
    end
  end

  describe "#notation_letter" do
    it 'returns B' do
      actual = bishop.notation_letter
      expect(actual).to eq('B')
    end
  end

  describe "#actions" do
    context 'when on c4' do
      bishop_position = Position.new('c4')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      bishop_at_c4 = described_class.new(position: bishop_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new(pieces: [bishop_at_c4])
          @bishop_actions = bishop_at_c4.actions(@game_state)
        end
        
        it 'has 11 possible moves' do
          actual = @bishop_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(11)
        end

        it 'can move to d3' do
          expect(@bishop_actions).to be_available_move(Position.new('d3'))
        end

        it 'can move to e2' do
          expect(@bishop_actions).to be_available_move(Position.new('e2'))
        end

        it 'can move to f1' do
          expect(@bishop_actions).to be_available_move(Position.new('f1'))
        end

        it 'can move to b3' do
          expect(@bishop_actions).to be_available_move(Position.new('b3'))
        end

        it 'can move to a2' do
          expect(@bishop_actions).to be_available_move(Position.new('a2'))
        end

        it 'can move to b5' do
          expect(@bishop_actions).to be_available_move(Position.new('b5'))
        end

        it 'can move to a6' do
          expect(@bishop_actions).to be_available_move(Position.new('a6'))
        end

        it 'can move to d5' do
          expect(@bishop_actions).to be_available_move(Position.new('d5'))
        end

        it 'can move to e6' do
          expect(@bishop_actions).to be_available_move(Position.new('e6'))
        end

        it 'can move to f7' do
          expect(@bishop_actions).to be_available_move(Position.new('f7'))
        end

        it 'can move to g8' do
          expect(@bishop_actions).to be_available_move(Position.new('g8'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['b5', 'e2', 'e6']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [bishop_at_c4])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @bishop_actions = bishop_at_c4.actions(@game_state)
          end

          it 'has 4 possible moves' do
            actual = @bishop_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(4)
          end

          it 'can move to d5' do
            expect(@bishop_actions).to be_available_move(Position.new('d5'))
          end

          it 'can move to d3' do
            expect(@bishop_actions).to be_available_move(Position.new('d3'))
          end

          it 'can move to b3' do
            expect(@bishop_actions).to be_available_move(Position.new('b3'))
          end

          it 'can move to a2' do
            expect(@bishop_actions).to be_available_move(Position.new('a2'))
          end
        end
      end

      context 'when blocked by enemy pieces' do
        enemy_positions = ['a2', 'a6', 'd3', 'd5']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new(pieces: [bishop_at_c4])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @bishop_actions = bishop_at_c4.actions(@game_state)
          end

          it 'has 2 possible moves' do
            actual = @bishop_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(2)
          end

          it 'can move to b3' do
            expect(@bishop_actions).to be_available_move(Position.new('b3'))
          end

          it 'can move to b5' do
            expect(@bishop_actions).to be_available_move(Position.new('b5'))
          end

          it 'has 4 possible captures' do
            actual = @bishop_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(4)
          end

          it 'can capture a2' do
            expect(@bishop_actions).to be_available_capture(Position.new('a2'))
          end

          it 'can capture a6' do
            expect(@bishop_actions).to be_available_capture(Position.new('d3'))
          end

          it 'can capture d3' do
            expect(@bishop_actions).to be_available_capture(Position.new('d3'))
          end

          it 'can capture d5' do
            expect(@bishop_actions).to be_available_capture(Position.new('d5'))
          end
        end
      end
    end
  end
end
