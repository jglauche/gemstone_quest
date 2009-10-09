class Malachite < Gemstone
  has_behaviors :updatable, :layered => {:layer => 3}
  

  def setup
    @range = 100
    @color = [0,255,0]
    @saturation = 40
    @recharge_time = 1000
    @min_damage = 3
    @max_damage = 6
    @melting_point = 164
    super
  end
  

end