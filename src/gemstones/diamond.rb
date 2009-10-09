class Diamond < Gemstone
  has_behaviors :updatable, :layered => {:layer => 3}
    
  def setup
    @range = 110
    @color = [251,255,241]
    @saturation = 50
    @recharge_time = 2500
    @min_damage = 15
    @max_damage = 25
    @melting_point = 3550
    super
  end
  
  # idea for special effect:
  # 2 percent chance of insta-kill
  
  
end