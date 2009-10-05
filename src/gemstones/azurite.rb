class Azurite < Gemstone
  has_behaviors :updatable, :layered => {:layer => 3}
  
  def setup
    @range = 80
    @color = [0,0,255]
    @saturation = 50
    @recharge_time = 300
    @min_damage = 2
    @max_damage = 5
    @melting_point = 200
  end
  

end