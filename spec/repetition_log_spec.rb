require_relative '../lib/repetition_log'

describe RepetitionLog do
  describe '#update' do
    subject(:repetition_log) { described_class.new }

    it 'logs the input string' do
      expect {
        repetition_log.update('test string')
      }.to change { repetition_log.repetitions }.from(0).to(1)
    end
  end

  describe '#repetitions' do
    subject(:repetition_log) { described_class.new }
    let(:two_times) { 'occurs twice' }

    before do
      repetition_log.update(two_times)
      repetition_log.update('something else')
    end

    it 'returns the maximum repetitions found' do
      expect {
        repetition_log.update(two_times)
      }.to change { repetition_log.repetitions }.from(1).to(2)
    end
  end
end