module Models
  class Grid
    attr_reader :ships, :layout, :grid_size

    def initialize(grid_size=5)
      @ships = []
      @grid_size = grid_size
      build_layout(grid_size)
    end

    def display
      alph_letters = ("a".."z").to_a
      layout.each_with_index do |row, index|
        positions = row.map.with_index do |r, i|
          if ships && ships.map(&:positions).flatten(1).find { |position| position[0] == index && position[1] == i}
            "o"
          else
            "*"
          end
        end.join(' ')

        puts "#{alph_letters[index]} #{positions}"
      end
      puts " #{layout.first.map.with_index {|row, index| index + 1 }.join(' ')}"
    end

    def dispose_ship(ship, position_start, position_end)
      ship.positions = full_position(matching_positon_points(position_start), matching_positon_points(position_end))
      ships << ship
      display
    end

    def placement_valid?(ship, position_start, position_end)
      first_point = matching_positon_points(position_start)
      second_point = matching_positon_points(position_end)

      unless (first_point + second_point).all? { |point| (0...grid_size).to_a.include?(point) }
        puts "Unexisting position"
        return false
      end

      if first_point[0] == second_point[0]
        unless first_point[1] < second_point[1]
          puts "Incoherent position"
          return false
        end
      elsif first_point[1] == second_point[1]
        unless first_point[0] < second_point[0]
          puts "Incoherent position"
          return false
        end
      else
        puts "Incoherent position"
        return false
      end

      if first_point[0] == second_point[0]
        unless (first_point[1]..second_point[1]).to_a.length == ship.length
          puts "Your position doesn't match your ship length"
          return false
        end
      elsif first_point[1] == second_point[1]
        unless (first_point[0]..second_point[0]).to_a.length == ship.length
          puts "Your position doesn't match your ship length"
          return false
        end
      end

      full_position = full_position(first_point, second_point)

      if ships
        if ships.map(&:positions).flatten(1).any? { |point| full_position.include?(point) }
          puts "Position still taken"
          return false
        end
      end

      true
    end

    def receive_shoot(position)
      matching_position = matching_positon_points(position)
      damaged_ship = ships.find do |ship|
        ship.positions.include?(matching_position)
      end

      if damaged_ship
        damaged_ship.damage(matching_position)
        puts "Hit!"
        puts "I sink..." if damaged_ship.is_sunk?
      else
        puts "Miss"
      end
    end

    private

    def build_layout(size)
      @layout = [].tap do |data|
        size.times do
          arr = []
          size.times { arr.push(false) }
          data.push(arr)
        end
      end
    end

    def full_position(first_point, second_point)
      if first_point[0] == second_point[0]
        from_to = (first_point[1]..second_point[1]).to_a
        from_to.map { |x| [first_point[0], x] }
      elsif first_point[1] == second_point[1]
        from_to = (first_point[0]..second_point[0]).to_a
        from_to.map { |x| [x, first_point[1]] }
      end
    end

    def matching_positon_points(position_key)
      letters = ("a".."z").to_a
      x, y = position_key.split('')
      [
        letters.find_index(x),
        (0...grid_size).to_a.find_index(y.to_i - 1)
      ]
    end
  end
end
