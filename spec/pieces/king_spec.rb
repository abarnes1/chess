# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/game_state'
require_relative 'shared/default_castling'
require_relative 'shared/default_castling_partner'
require_relative 'shared/default_check'
require_relative 'shared/default_en_passant'
require_relative 'shared/piece_custom_matchers'

describe King do
  # before do
  #   allow($stdout).to receive(:puts)
  # end

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

  # Knight has no special behaviors
  context "when #{described_class.name} implements default behaviors" do
    # include_examples 'default castling behavior'
    include_examples 'default castling partner behavior'
    include_examples 'default en passant behavior'
  end

  describe '#can_castle?' do
    context 'when on e1 and has not moved' do
      friendly_owner = 'player1'
      king_position = Position.new('e1')
      king_at_e1 = King.new(position: king_position, owner: friendly_owner)

      context 'when partner on a1 is valid partner and has not moved' do
        partner_position = Position.new('a1')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e1)
          @game_state.add_piece(@partner)
        end

        it 'returns true' do
          actual = king_at_e1.can_castle?(@game_state)
          expect(actual).to be true
        end
      end

      context 'when partner on a1 is valid partner and has moved' do
        partner_position = Position.new('a1')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e1)
          @game_state.add_piece(@partner)
          @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('a2')))
          @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('a1')))
        end

        it 'returns false' do
          actual = king_at_e1.can_castle?(@game_state)
          expect(actual).to be false
        end
      end

        context 'when partner on h1 is valid partner and has not moved' do
          partner_position = Position.new('h1')
  
          before(:all) do
            @game_state = GameState.new
            @partner = Rook.new(position: partner_position, owner: friendly_owner)
            @game_state.add_piece(king_at_e1)
            @game_state.add_piece(@partner)
          end
  
          it 'returns true' do
            actual = king_at_e1.can_castle?(@game_state)
            expect(actual).to be true
          end
        end
  
        context 'when partner on h1 is valid partner and has moved' do
          partner_position = Position.new('h1')
  
          before(:all) do
            @game_state = GameState.new
            @partner = Rook.new(position: partner_position, owner: friendly_owner)
            @game_state.add_piece(king_at_e1)
            @game_state.add_piece(@partner)
            @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('g2')))
            @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('g1')))
          end
  
          it 'returns false' do
            actual = king_at_e1.can_castle?(@game_state)
            expect(actual).to be false
          end
      end
    end

    context 'when on e1 and has moved' do
      friendly_owner = 'player1'
      king_position = Position.new('e1')
      king_at_e1 = King.new(position: king_position, owner: friendly_owner)

      context 'when partner on a1 is valid partner and has not moved' do
        partner_position = Position.new('a1')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e1)
          @game_state.add_piece(@partner)

          @game_state.apply_action(Move.new(king_at_e1, king_at_e1.position, Position.new('e2')))
          @game_state.apply_action(Move.new(king_at_e1, king_at_e1.position, Position.new('e1')))
        end

        it 'returns false' do
          actual = king_at_e1.can_castle?(@game_state)
          expect(actual).to be false
        end
      end

      context 'when partner on h1 is valid partner and has not moved' do
        partner_position = Position.new('h1')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e1)
          @game_state.add_piece(@partner)

          @game_state.apply_action(Move.new(king_at_e1, king_at_e1.position, Position.new('e2')))
          @game_state.apply_action(Move.new(king_at_e1, king_at_e1.position, Position.new('e1')))
        end

        it 'returns false' do
          actual = king_at_e1.can_castle?(@game_state)
          expect(actual).to be false
        end
      end
    end

    context 'when on e8 and has not moved' do
      friendly_owner = 'player1'
      king_position = Position.new('e8')
      king_at_e8 = King.new(position: king_position, owner: friendly_owner)

      context 'when partner on a8 is valid partner and has not moved' do
        partner_position = Position.new('a8')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e8)
          @game_state.add_piece(@partner)
        end

        it 'returns true' do
          actual = king_at_e8.can_castle?(@game_state)
          expect(actual).to be true
        end
      end

      context 'when partner on a8 is valid partner and has moved' do
        partner_position = Position.new('a8')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e8)
          @game_state.add_piece(@partner)
          @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('a8')))
          @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('a7')))
        end

        it 'returns false' do
          actual = king_at_e8.can_castle?(@game_state)
          expect(actual).to be false
        end
      end

        context 'when partner on h8 is valid partner and has not moved' do
          partner_position = Position.new('h8')
  
          before(:all) do
            @game_state = GameState.new
            @partner = Rook.new(position: partner_position, owner: friendly_owner)
            @game_state.add_piece(king_at_e8)
            @game_state.add_piece(@partner)
          end
  
          it 'returns true' do
            actual = king_at_e8.can_castle?(@game_state)
            expect(actual).to be true
          end
        end
  
        context 'when partner on h8 is valid partner and has moved' do
          partner_position = Position.new('h8')
  
          before(:all) do
            @game_state = GameState.new
            @partner = Rook.new(position: partner_position, owner: friendly_owner)
            @game_state.add_piece(king_at_e8)
            @game_state.add_piece(@partner)
            @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('g2')))
            @game_state.apply_action(Move.new(@partner, @partner.position, Position.new('g1')))
          end
  
          it 'returns false' do
            actual = king_at_e8.can_castle?(@game_state)
            expect(actual).to be false
          end
      end
    end

    context 'when on e8 and has moved' do
      friendly_owner = 'player1'
      king_position = Position.new('e8')
      king_at_e8 = King.new(position: king_position, owner: friendly_owner)

      context 'when partner on a1 is valid partner and has not moved' do
        partner_position = Position.new('a1')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e8)
          @game_state.add_piece(@partner)

          @game_state.apply_action(Move.new(king_at_e8, king_at_e8.position, Position.new('e7')))
          @game_state.apply_action(Move.new(king_at_e8, king_at_e8.position, Position.new('e8')))
        end

        it 'returns false' do
          actual = king_at_e8.can_castle?(@game_state)
          expect(actual).to be false
        end
      end

      context 'when partner on h8 is valid partner and has not moved' do
        partner_position = Position.new('h8')

        before(:all) do
          @game_state = GameState.new
          @partner = Rook.new(position: partner_position, owner: friendly_owner)
          @game_state.add_piece(king_at_e8)
          @game_state.add_piece(@partner)

          @game_state.apply_action(Move.new(king_at_e8, king_at_e8.position, Position.new('e7')))
          @game_state.apply_action(Move.new(king_at_e8, king_at_e8.position, Position.new('e8')))
        end

        it 'returns false' do
          actual = king_at_e8.can_castle?(@game_state)
          expect(actual).to be false
        end
      end
    end
  end

  describe "#can_be_checked?" do
    it 'return true' do
      actual = king.can_be_checked?
      expect(actual).to be true
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
          @game_state = GameState.new([king_at_c4])
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
            @game_state = GameState.new([king_at_c4])

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
            @game_state = GameState.new([king_at_c4])

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
      king_position = Position.new('e1')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      king_at_e1 = described_class.new(position: king_position, owner: friendly_owner)

      partner_positions = ['a1', 'h1']

      context "when castling partners at #{partner_positions.join(', ')}" do
        context 'when no enemy pieces' do
          before(:all) do
            @game_state = GameState.new([king_at_e1])

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

      context 'when enemies block castling' do
        enemy_positions = ['c4', 'f4']

        before(:all) do
          @game_state = GameState.new([king_at_e1])

          partner_positions.each do |position|
            @game_state.add_piece(Rook.new(position: Position.new(position), owner: friendly_owner))
          end

          enemy_positions.each do |position|
            @game_state.add_piece(Rook.new(position: Position.new(position), owner: enemy_owner))
          end

          @king_actions = king_at_e1.actions(@game_state)
        end

        it 'has 0 possible castling actions' do
          actual = @king_actions.select { |action| action.is_a?(Castling)}.size
          expect(actual).to eq(0)
        end
      end
    end

    context 'when on e8' do
      king_position = Position.new('e8')
      friendly_owner = 'player1'
      enemy_owner = 'player2'
      king_at_e8 = described_class.new(position: king_position, owner: friendly_owner)

      partner_positions = ['a8', 'h8']

      context "when castling partners at #{partner_positions.join(', ')}" do
        context 'when no enemy pieces' do
          before(:all) do
            @game_state = GameState.new([king_at_e8])

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

      context 'when enemies block castling' do
        enemy_positions = ['c4', 'f4']

        before(:all) do
          @game_state = GameState.new([king_at_e8])

          partner_positions.each do |position|
            @game_state.add_piece(Rook.new(position: Position.new(position), owner: friendly_owner))
          end

          enemy_positions.each do |position|
            @game_state.add_piece(Rook.new(position: Position.new(position), owner: enemy_owner))
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
end
