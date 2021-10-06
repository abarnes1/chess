# Default en passant behavior where game state does not
# matter and should always return the same value.

RSpec.shared_examples 'default en passant behavior' do
  context '#can_en_passant?' do
    it 'returns false' do
      actual = subject.can_en_passant?
      expect(actual).to be false
    end
  end
end