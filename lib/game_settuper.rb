class GameSettuper
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def dispose_ship_steps(ship)
    puts "Please place your ships on your grid #{player.name}"
    player.grid.display
    puts "Place your first ship, its size is #{ship.length}x#{ship.width}"
    puts "To place your ship on the grid you need to enter its position start and end. ex: 'a1'"
    puts "Position start:"
    ship_1_position_start = gets.chomp
    puts "Position end:"
    ship_1_position_end = gets.chomp
    dispose_ship(ship, ship_1_position_start, ship_1_position_end)
  end

  private

  def dispose_ship(ship, position_start, position_end)
    if player.grid.placement_valid?(ship, position_start, position_end)
      player.dispose_ship(ship, position_start, position_end)
    else
      dispose_ship_steps(ship)
    end
  end
end
