require_relative '../lib/castling_rights'

describe CastlingRights do
  let(:white_player) { double('white_player') }
  let(:black_player) { double('black_player') }

  describe '#player_pairs' do
    context 'when for the white player' do
      context 'when no updates have been made' do
        subject(:white_rights) { described_class.new(white: white_player) }

        it 'returns two pairs' do
          actual = white_rights.player_pairs(white_player).size

          expect(actual).to eq(2)
        end

        context 'when returning the king side pair' do
          let(:white_rights) { described_class.new(white: white_player ) }

          it 'has a king position of e1' do
            king_side = white_rights.player_pairs(white_player)[0]
            actual = king_side.king_position

            expect(actual).to eq(Position.new('e1'))
          end

          it 'has a rook position of a1' do
            king_side = white_rights.player_pairs(white_player)[0]
            actual = king_side.rook_position

            expect(actual).to eq(Position.new('h1'))
          end
        end

        context 'when returning the queen side pair' do
          let(:white_rights) { described_class.new(white: white_player ) }

          it 'has a king position of e1' do
            queen_side = white_rights.player_pairs(white_player)[1]
            actual = queen_side.king_position

            expect(actual).to eq(Position.new('e1'))
          end

          it 'has a rook position of a1' do
            queen_side = white_rights.player_pairs(white_player)[1]
            actual = queen_side.rook_position

            expect(actual).to eq(Position.new('a1'))
          end
        end
      end
    end

    context 'when for the black player' do
      context 'when no updates have been made' do
        subject(:black_rights) { described_class.new(black: black_player) }

        it 'returns two pairs' do
          actual = black_rights.player_pairs(black_player).size

          expect(actual).to eq(2)
        end

        context 'when returning the king side pair' do
          subject(:black_rights) { described_class.new(black: black_player) }

          it 'has a king position of e8' do
            king_side = black_rights.player_pairs(black_player)[0]
            actual = king_side.king_position

            expect(actual).to eq(Position.new('e8'))
          end

          it 'has a rook position of a8' do
            king_side = black_rights.player_pairs(black_player)[0]
            actual = king_side.rook_position

            expect(actual).to eq(Position.new('h8'))
          end
        end

        context 'when returning the queen side pair' do
          subject(:black_rights) { described_class.new(black: black_player) }

          it 'has a king position of e8' do
            queen_side = black_rights.player_pairs(black_player)[1]
            actual = queen_side.king_position

            expect(actual).to eq(Position.new('e8'))
          end

          it 'has a rook position of a8' do
            queen_side = black_rights.player_pairs(black_player)[1]
            actual = queen_side.rook_position

            expect(actual).to eq(Position.new('a8'))
          end
        end
      end
    end

    context 'when player is not valid' do
      subject(:rights) { described_class.new }

      it 'returns two pairs' do
        actual = rights.player_pairs(Object.new)

        expect(actual).to be_empty
      end
    end
  end

  describe '#to_fen_component' do
    context 'when no updates have been made' do
      subject(:rights) { described_class.new(white: white_player, black: black_player) }

      it 'returns KQkq' do
        actual = rights.to_fen_component

        expect(actual).to eq('KQkq')
      end
    end

    context 'white queen side is no longer valid' do
      subject(:rights) { described_class.new(white: white_player, black: black_player) }

      it 'returns Kkq' do
        rights.update(Position.new('a1'))
        actual = rights.to_fen_component

        expect(actual).to eq('Kkq')
      end
    end

    context 'white king side is no longer valid' do
      subject(:rights) { described_class.new(white: white_player, black: black_player) }

      it 'returns Kkq' do
        rights.update(Position.new('h1'))
        actual = rights.to_fen_component

        expect(actual).to eq('Qkq')
      end
    end

    context 'black queen side is no longer valid' do
      subject(:rights) { described_class.new(white: white_player, black: black_player) }

      it 'returns KQk' do
        rights.update(Position.new('a8'))
        actual = rights.to_fen_component

        expect(actual).to eq('KQk')
      end
    end

    context 'black king side is no longer valid' do
      subject(:rights) { described_class.new(white: white_player, black: black_player) }

      it 'returns KQq' do
        rights.update(Position.new('h8'))
        actual = rights.to_fen_component

        expect(actual).to eq('KQq')
      end
    end

    context 'when no enabled pairs' do
      subject(:rights) { described_class.new(white: white_player, black: black_player) }

      it 'returns -' do
        rights.update(Position.new('e1'))
        rights.update(Position.new('e8'))
        actual = rights.to_fen_component

        expect(actual).to eq('-')
      end
    end
  end
end