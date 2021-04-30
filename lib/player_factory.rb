require_relative "models/grid"
require_relative "models/player"
require_relative "models/ship"

class PlayerFactory
  attr_reader :player

  def initialize(name)
    @player = Models::Player.new(name, Models::Grid.new, [Models::Ship.new(3,1), Models::Ship.new(4,1)])
  end
end
