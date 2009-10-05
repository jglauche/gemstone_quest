class Ruby < Gemstone
  has_behaviors :updatable, :layered => {:layer => 3}
  
  def setup
    @range = 105
    @color = [255,0,0]
    @saturation = 30
    @recharge_time = 1400
    @min_damage = 4
    @max_damage = 6
    @melting_point = 2050

  end
  

end