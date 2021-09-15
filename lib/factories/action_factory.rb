Dir['../actions/*.rb'].sort.each { |file| require file }

# require_relative '../actions/*'

class ActionFactory
  def initialize; end

  def self.create_action(action_type, *args)
    # puts "MoveFactory for type: #{action_type}"

    action_type.new(*args)
  end
end
