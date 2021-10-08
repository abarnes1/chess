RSpec::Matchers.define :be_available_move do |expected|
  match do |actions|
    actions.any? { |action| action.is_a?(Move) && action.move_to == expected}
  end

  failure_message do
    "#{described_class} can't move to #{expected} but should"
  end

  failure_message_when_negated do
    "#{described_class} should not have a move to #{expected}"
  end
end

RSpec::Matchers.define :be_available_capture do |position|
  match do |actions|
    actions.any? { |action| action.is_a?(Capture) && action.move_to == position}
  end

  failure_message do
    "#{described_class} can't capture #{position} but should"
  end

  failure_message_when_negated do
    "#{described_class} should not have a capture to #{position}"
  end
end

RSpec::Matchers.define :be_available_promote do |position|
  match do |actions|
    actions.any? { |action| action.is_a?(Promote) && action.move_to == position}
  end

  failure_message do
    "#{described_class} can't promote at #{position} but should"
  end

  failure_message_when_negated do
    "#{described_class} should not have a promote at #{position}"
  end
end

RSpec::Matchers.define :be_available_promote_capture do |position|
  match do |actions|
    actions.any? { |action| action.is_a?(PromoteCapture) && action.move_to == position}
  end

  failure_message do
    "#{described_class} can't promote capture at #{position} but should"
  end

  failure_message_when_negated do
    "#{described_class} should not have a promote capture at #{position}"
  end
end

RSpec::Matchers.define :be_available_en_passant do |position|
  match do |actions|
    actions.any? { |action| action.is_a?(EnPassant) && action.move_to == position}
  end

  failure_message do
    "#{described_class} can't en passant at #{position} but should"
  end

  failure_message_when_negated do
    "#{described_class} should not have an en passant at #{position}"
  end
end

RSpec::Matchers.define :be_available_castling do |position|
  match do |actions|
    actions.any? { |action| action.is_a?(Castling) && action.move_to == position}
  end

  failure_message do
    "#{described_class} can't castle to #{position} but should"
  end

  failure_message_when_negated do
    "#{described_class} should not castle at #{position}"
  end
end