class Action
  def initialize(*args)

  end

  def apply
    puts 'no apply override!'
  end

  def notation
    puts 'no notation override!'
  end

  def to_s
    raise NotImplementedError
  end
end