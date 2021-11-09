class RepetitionLog
  def initialize(log = Hash.new(0))
    @log = log
  end

  def update(repetition_value)
    key = repetition_value.to_sym

    log[key] += 1
  end

  def repetitions
    if log.empty?
      0
    else
      log.max_by { |_, value| value }[1]
    end
  end

  private

  attr_reader :log
end