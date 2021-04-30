require "./models/grid"
require "./models/ship"

describe Models::Grid do
  describe "Checks layout" do
    it "Without size given" do
      grid = Models::Grid.new
      expect(grid.layout.length).to eq 5
      expect(grid.layout.first.length).to eq 5
    end

    it "With size given" do
      grid = Models::Grid.new(10)
      expect(grid.layout.length).to eq 10
      expect(grid.layout.first.length).to eq 10
    end
  end

  describe "Valid position" do
    before do
      @grid = Models::Grid.new
      @ship = Models::Ship.new(4, 1)
    end

    it "Returns false when unexisting position" do
      expect(@grid.placement_valid?(@ship, "ff", "b100")).to be_falsey
    end

    it "Returs false with incohenret positions" do
      # 5 < 0
      expect(@grid.placement_valid?(@ship, "a5", "a0")).to be_falsey
      # e < a
      expect(@grid.placement_valid?(@ship, "e1", "a1")).to be_falsey
      # diagonal
      expect(@grid.placement_valid?(@ship, "a1", "e5")).to be_falsey
    end

    it "Returns false when not matching the ship length" do
      # ship length == 4
      expect(@grid.placement_valid?(@ship, "a1", "a2")).to be_falsey
      expect(@grid.placement_valid?(@ship, "a1", "a5")).to be_falsey
    end

    it "Returns false when position is still taken by a ship" do
      @grid.dispose_ship(@ship, "a1", "a4")
      expect(@grid.ships.length).to eq 1
      expect(@grid.ships.first).to eq @ship
      expect(@grid.ships.first.positions).to eq([[0,0], [0,1], [0,2], [0,3]])

      ship = Models::Ship.new(3, 1)
      expect(@grid.placement_valid?(ship, "a1", "c3")).to be_falsey
    end

    it "Returns true when everything works well" do
      ship = Models::Ship.new(3, 1)
      expect(@grid.placement_valid?(ship, "a1", "a3")).to be_truthy
    end
  end

  describe "Receive shoot working well" do
    before do
      @grid = Models::Grid.new
      @ship = Models::Ship.new(4, 1)
      @grid.dispose_ship(@ship, "a1", "a3")
    end

    it "Damage  the boat when touched" do
      expect(@grid.ships.first.damages.length).to eq 0
      @grid.receive_shoot("a2")
      expect(@grid.ships.first.damages.length).to eq 1
    end

    it "Doesn't damage the boat when touched" do
      expect(@grid.ships.first.damages.length).to eq 0
      @grid.receive_shoot("e1")
      expect(@grid.ships.first.damages.length).to eq 0
    end
  end
end


