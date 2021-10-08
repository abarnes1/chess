RSpec.shared_examples 'default castling partner behavior' do
  context '#castling_partner?' do
    it 'returns false' do
      actual = subject.castling_partner?
      expect(actual).to be false
    end
  end
end