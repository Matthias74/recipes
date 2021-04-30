module Models
  class Ship
    attr_reader :width, :length
    attr_accessor :positions, :damages

    def initialize(length, width)
      @length = length
      @width = width
      @damages = []
      @positions = []
    end

    def damage(damage_position)
      damages.push(damage_position)
    end

    def is_sunk?
      return false if damages.uniq.length != positions.length
      positions.all? do |position|
        damages.include?(position)
      end
    end
  end
end
