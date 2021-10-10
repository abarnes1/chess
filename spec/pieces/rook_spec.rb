# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/game_state'
require_relative 'shared/default_castling'
require_relative 'shared/default_castling_partner'
require_relative 'shared/default_check'
require_relative 'shared/default_en_passant'
require_relative 'shared/piece_custom_matchers'

describe Rook do
  subject(:rook) { described_class.new(position: Position.new('c4')) }

  describe '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        RepeatOffset.new([1, 0]),
        RepeatOffset.new([-1, 0]),
        RepeatOffset.new([0, 1]),
        RepeatOffset.new([0, -1])
      ]

      actual = rook.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  describe '#movement_offsets' do
    it 'has the correct movement offsets' do
      expected = [
        RepeatOffset.new([1, 0]),
        RepeatOffset.new([-1, 0]),
        RepeatOffset.new([0, 1]),
        RepeatOffset.new([0, -1])
      ]

      actual = rook.move_offsets

      expect(actual).to eq(expected)
    end
  end

  describe "#notation_letter" do
    it 'returns R' do
      actual = rook.notation_letter
      expect(actual).to eq('R')
    end
  end
  
  context "when #{described_class.name} implements default behaviors" do
    include_examples 'default castling behavior'
    include_examples 'default check behavior'
    include_examples 'default en passant behavior'
  end

  context "when #{described_class.name} has special behavior" do
    context '#castling_partner?' do
      it 'returns true' do
        expect(rook).to be_castling_partner
      end
    end
  end

  describe "#actions" do
    context 'when on c4' do
      rook_position = Position.new('c4')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      rook_at_c4 = described_class.new(position: rook_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new([rook_at_c4])
          @rook_actions = rook_at_c4.actions(@game_state)
        end
        
        it 'has 14 possible moves' do
          actual = @rook_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(14)
        end

        it 'can move to d4' do
          expect(@rook_actions).to be_available_move(Position.new('d4'))
        end

        it 'can move to e4' do
          expect(@rook_actions).to be_available_move(Position.new('e4'))
        end

        it 'can move to f4' do
          expect(@rook_actions).to be_available_move(Position.new('f4'))
        end

        it 'can move to g4' do
          expect(@rook_actions).to be_available_move(Position.new('g4'))
        end

        it 'can move to h4' do
          expect(@rook_actions).to be_available_move(Position.new('h4'))
        end

        it 'can move to c3' do
          expect(@rook_actions).to be_available_move(Position.new('c3'))
        end

        it 'can move to c2' do
          expect(@rook_actions).to be_available_move(Position.new('c2'))
        end

        it 'can move to c1' do
          expect(@rook_actions).to be_available_move(Position.new('c1'))
        end

        it 'can move to b4' do
          expect(@rook_actions).to be_available_move(Position.new('b4'))
        end

        it 'can move to a4' do
          expect(@rook_actions).to be_available_move(Position.new('a4'))
        end

        it 'can move to c5' do
          expect(@rook_actions).to be_available_move(Position.new('c5'))
        end

        it 'can move to c6' do
          expect(@rook_actions).to be_available_move(Position.new('c6'))
        end

        it 'can move to c7' do
          expect(@rook_actions).to be_available_move(Position.new('c7'))
        end

        it 'can move to c8' do
          expect(@rook_actions).to be_available_move(Position.new('c8'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['a4', 'c7', 'd4']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([rook_at_c4])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @rook_actions = rook_at_c4.actions(@game_state)
          end

          it 'has 6 possible moves' do
            actual = @rook_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(6)
          end

          it 'can move to c3' do
            expect(@rook_actions).to be_available_move(Position.new('c3'))
          end

          it 'can move to c2' do
            expect(@rook_actions).to be_available_move(Position.new('c2'))
          end

          it 'can move to c1' do
            expect(@rook_actions).to be_available_move(Position.new('c1'))
          end

          it 'can move to b4' do
            expect(@rook_actions).to be_available_move(Position.new('b4'))
          end

          it 'can move to c5' do
            expect(@rook_actions).to be_available_move(Position.new('c5'))
          end

          it 'can move to c6' do
            expect(@rook_actions).to be_available_move(Position.new('c6'))
          end
        end
      end

      context 'when blocked by enemy pieces' do
        enemy_positions = ['b4', 'c2', 'c5', 'f4']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([rook_at_c4])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @rook_actions = rook_at_c4.actions(@game_state)
          end

          it 'has 3 possible moves' do
            actual = @rook_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(3)
          end

          it 'can move to c3' do
            expect(@rook_actions).to be_available_move(Position.new('c3'))
          end

          it 'can move to d4' do
            expect(@rook_actions).to be_available_move(Position.new('d4'))
          end

          it 'can move to e4' do
            expect(@rook_actions).to be_available_move(Position.new('e4'))
          end

          it 'has 4 possible captures' do
            actual = @rook_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(4)
          end

          it 'can capture b4' do
            expect(@rook_actions).to be_available_capture(Position.new('b4'))
          end

          it 'can capture c2' do
            expect(@rook_actions).to be_available_capture(Position.new('c2'))
          end

          it 'can capture c5' do
            expect(@rook_actions).to be_available_capture(Position.new('c5'))
          end

          it 'can capture f4' do
            expect(@rook_actions).to be_available_capture(Position.new('f4'))
          end
        end
      end
    end
  end
end
