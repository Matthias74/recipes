module Models
  class Player
    attr_reader :name, :grid, :ships
    attr_accessor :opponent

    def initialize(name, grid, ships)
      @name = name
      @grid = grid
      @ships = ships
    end

    def dispose_ship(ship, position_start, position_end)
      grid.dispose_ship(ship, position_start, position_end)
    end

    def shoot(position)
      opponent.grid.receive_shoot(position)
    end
  end
end
