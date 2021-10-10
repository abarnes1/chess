# frozen_string_literal: true

require_relative '../../lib/pieces/knight'
require_relative '../../lib/game_state'
require_relative 'shared/default_castling'
require_relative 'shared/default_castling_partner'
require_relative 'shared/default_check'
require_relative 'shared/default_en_passant'
require_relative 'shared/piece_custom_matchers'

describe Knight do
  subject(:knight) { described_class.new(position: Position.new('c4')) }

  describe '#capture_offsets' do
    it 'has the correct capture offsets' do
      expected = [
        Offset.new([2, -1]),
        Offset.new([2,  1]),
        Offset.new([1, -2]),
        Offset.new([-1, -2]),
        Offset.new([-2, 1]),
        Offset.new([-2, -1]),
        Offset.new([-1, 2]),
        Offset.new([1, 2])
      ]

      actual = knight.capture_offsets

      expect(actual).to eq(expected)
    end
  end

  describe '#movement_offsets' do
    it 'has the correct movement offsets' do
      expected = [
        Offset.new([2, -1]),
        Offset.new([2,  1]),
        Offset.new([1, -2]),
        Offset.new([-1, -2]),
        Offset.new([-2, 1]),
        Offset.new([-2, -1]),
        Offset.new([-1, 2]),
        Offset.new([1, 2])
      ]

      actual = knight.move_offsets

      expect(actual).to eq(expected)
    end
  end

  describe "#notation_letter" do
    it 'returns N' do
      actual = knight.notation_letter
      expect(actual).to eq('N')
    end
  end

  # Knight has no special behaviors
  context "when #{described_class.name} implements default behaviors" do
    include_examples 'default castling behavior'
    include_examples 'default castling partner behavior'
    include_examples 'default check behavior'
    include_examples 'default en passant behavior'
  end

  describe "#actions" do
    context 'when on c4' do
      knight_position = Position.new('c4')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      knight_at_c4 = described_class.new(position: knight_position, owner: friendly_owner)
  
      context 'when the only piece' do
        before(:all) do
          @game_state = GameState.new([knight_at_c4])
          @knight_actions = knight_at_c4.actions(@game_state)
        end
        
        it 'has 8 possible moves' do
          actual = @knight_actions.select { |action| action.is_a? Move}.size
          expect(actual).to eq(8)
        end

        it 'can move to e3' do
          expect(@knight_actions).to be_available_move(Position.new('e3'))
        end

        it 'can move to d2' do
          expect(@knight_actions).to be_available_move(Position.new('d2'))
        end

        it 'can move to b2' do
          expect(@knight_actions).to be_available_move(Position.new('b2'))
        end

        it 'can move to a3' do
          expect(@knight_actions).to be_available_move(Position.new('a3'))
        end

        it 'can move to a5' do
          expect(@knight_actions).to be_available_move(Position.new('a5'))
        end

        it 'can move to b6' do
          expect(@knight_actions).to be_available_move(Position.new('b6'))
        end

        it 'can move to d6' do
          expect(@knight_actions).to be_available_move(Position.new('d6'))
        end

        it 'can move to a5' do
          expect(@knight_actions).to be_available_move(Position.new('a5'))
        end
      end

      context 'when blocked by friendly pieces' do
        friendly_positions = ['a5', 'b2', 'd6', 'e3']

        context "when friendlies at #{friendly_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([knight_at_c4])

            friendly_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: friendly_owner))
            end

            @knight_actions = knight_at_c4.actions(@game_state)
          end

          it 'has 4 possible moves' do
            actual = @knight_actions.select { |action| action.is_a? Move}.size
            expect(actual).to eq(4)
          end

          it 'can move to a3' do
            expect(@knight_actions).to be_available_move(Position.new('a3'))
          end

          it 'can move to b6' do
            expect(@knight_actions).to be_available_move(Position.new('b6'))
          end

          it 'can move to d2' do
            expect(@knight_actions).to be_available_move(Position.new('d2'))
          end

          it 'can move to e5' do
            expect(@knight_actions).to be_available_move(Position.new('e5'))
          end
        end
      end

      context 'when blocked by enemy pieces' do
        enemy_positions = ['a3', 'a5', 'd2', 'd6']

        context "when enemies at #{enemy_positions.join(', ')}" do
          before(:all) do
            @game_state = GameState.new([knight_at_c4])

            enemy_positions.each do |position|
              @game_state.add_piece(ChessPiece.new(position: Position.new(position), owner: enemy_owner))
            end

            @knight_actions = knight_at_c4.actions(@game_state)
          end

          it 'has 4 possible moves' do
            actual = @knight_actions.select { |action| action.is_a?(Move)}.size
            expect(actual).to eq(4)
          end

          it 'can move to e3' do
            expect(@knight_actions).to be_available_move(Position.new('e3'))
          end

          it 'can move to e5' do
            expect(@knight_actions).to be_available_move(Position.new('e5'))
          end

          it 'can move to b2' do
            expect(@knight_actions).to be_available_move(Position.new('b2'))
          end

          it 'can move to b6' do
            expect(@knight_actions).to be_available_move(Position.new('b6'))
          end


          it 'has 4 possible captures' do
            actual = @knight_actions.select { |action| action.is_a?(Capture)}.size
            expect(actual).to eq(4)
          end

          it 'can capture a3' do
            expect(@knight_actions).to be_available_capture(Position.new('a3'))
          end

          it 'can capture a5' do
            expect(@knight_actions).to be_available_capture(Position.new('a5'))
          end

          it 'can capture d2' do
            expect(@knight_actions).to be_available_capture(Position.new('d2'))
          end

          it 'can capture d6' do
            expect(@knight_actions).to be_available_capture(Position.new('d6'))
          end
        end
      end
    end
  end
end
