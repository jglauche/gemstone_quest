class Ruby < Gemstone
  
  def setup
    @range = 105
    @color = [255,0,0]
    @saturation = 30
    @recharge_time = 1400
    @min_damage = 4
    @max_damage = 6
    @melting_point = 2050
    super
  end
  # ideas for special effect:
  # - chance of setting monster on fire
  # - explode on impact 

end