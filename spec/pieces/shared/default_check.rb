RSpec.shared_examples 'default check behavior' do
  context '#can_be_checked?' do
    it 'returns false' do
      actual = subject.can_be_checked?
      expect(actual).to be false
    end
  end
end