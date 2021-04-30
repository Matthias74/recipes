require_relative "game_settuper"
require_relative "player_factory"

class Game
  attr_reader :players, :player_1, :player_2, :start_random
  attr_accessor :current_player

  def initialize(players, start_random=true)
    @players = players
    @player_1 = players[0]
    @player_2 = players[1]
    @start_random = start_random
    setup
  end

  def setup
    setup_player_1 = GameSettuper.new(player_1)
    setup_player_2 = GameSettuper.new(player_2)
    setup_player_1.dispose_ship_steps(player_1.ships[0])
    setup_player_1.dispose_ship_steps(player_1.ships[1])
    setup_player_2.dispose_ship_steps(player_2.ships[0])
    setup_player_2.dispose_ship_steps(player_2.ships[1])
    player_1.opponent = player_2
    player_2.opponent = player_1

    @current_player = if start_random
      players.sample
    else
      player_1
    end

    play
  end

  private

  def play
    puts "Ready to shoot #{current_player.name}? Give a position to shoot!"
    position = gets.chomp
    shoot(position)
  end

  def shoot(position)
    puts current_player.name
    current_player.shoot(position)
    unless current_player.opponent.ships.map(&:is_sunk?).uniq.length == 1 && current_player.opponent.ships.map(&:is_sunk?).uniq.first == true
      @current_player = current_player.opponent
      play
    else
      puts "You won #{current_player.name}!"

      puts "Want to replay [Y/N]?"
      replay = gets.chomp
      if replay == "Y"
        self.class.new([PlayerFactory.new("Player 1").player, PlayerFactory.new("Player 2").player])
      else
        puts "Goodbye"
      end
    end
  end
end

