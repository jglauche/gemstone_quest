class Tower < Actor
  has_behaviors :graphical, :updatable,  :layered => {:layer => 2}
   
  attr_accessor :gemstone, :x, :y, :range
  
  def setup 
    @itemsize = 32
    @gem_drawing_position = [@x+8, @y+8]
    
    
    @gemstone = nil
    @recharge_time = 1000 # ms
  end
  
  def self.build_cost
    100
  end
  
  def reset_recharge_time
    return if @gemstone == nil
    @recharge_time = @gemstone.recharge_time
  end
  
  def take_gem(gem)
    gem.x = @x+8
    gem.y = @y+8
    oldgem = @gemstone
    @gemstone = gem
    reset_recharge_time    
    return oldgem
  end
  
  def hovered?(mouse)
    x,y = @screen_pos
    in_bounds?(mouse, x,y, @itemsize, @itemsize)
  end  
    
  def range
    if @gemstone == nil
      return 0
    end
    return @gemstone.range
  end
  
  def tick(last_tick_time)
    @recharge_time -= last_tick_time
  end
  
#  def draw(surface)
#    if @gemstone
#      @gemstone.draw(surface, @gem_drawing_position)
#    end
#  end
  
#  def draw_radius(surface)
#    surface.draw_circle_a(get_center_pos, range, [255,255,255,90])
#  end
  
  def ready?
    return false if @gemstone == nil
    return false if @recharge_time > 0
    true  
  end
  
  def get_center_pos
    x,y = @x, @y
    # calculate range from center of the tower
    x += ITEMSIZE/2  
    y += ITEMSIZE/2
    [x,y]
  end
  

    
  def fire_at_monsters_in_range(monsters)
    dist = monsters.map{|m| get_distance(get_center_pos, m.get_position)}
    
    # TODO: fire at the one with shortest distance or loweset HP or so
    monsters.each_with_index do |monster, i|
      if dist[i] <= range
        fire!(monster)
        return
      end 
    end    
    
    #puts "Monster distances = #{dist}" 
    
  end
  
  def fire!(monster)
    reset_recharge_time
    Particle.fire_particle(get_center_pos, monster, @gemstone.get_damage, @gemstone.get_color)
    #monster.take_damage(1)
  end

  
end