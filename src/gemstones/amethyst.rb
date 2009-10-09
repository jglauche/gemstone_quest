class Amethyst < Gemstone
  has_behaviors :updatable, :layered => {:layer => 3}
    
  def setup
    @range = 100
    @color = [129,47,218]
    @saturation = 30
    @recharge_time = 1000
    @min_damage = 2
    @max_damage = 5
    @melting_point = 1650
    super
  end

  
end