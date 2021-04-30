require_relative "game"
require_relative "player_factory"

Game.new([PlayerFactory.new("Player 1").player, PlayerFactory.new("Player 2").player])
