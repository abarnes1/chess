RSpec.shared_examples 'default castling behavior' do
  context '#can_castle?' do
    it 'returns false' do
      actual = subject.can_castle?
      expect(actual).to be false
    end
  end

  context '#valid_castling_partners?' do
    it 'returns no castling partners' do
      actual = subject.valid_castling_partners(nil)
      expect(actual).to be_nil
    end
  end
end