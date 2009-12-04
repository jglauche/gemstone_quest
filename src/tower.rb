class TowerView < ActorView
  def draw(target, x_off, y_off)
    x,y = actor.x, actor.y
    
    img = stage.resource_manager.load_image "tower.png"
    img.blit(target.screen,[x, y]) 
    if actor.gem_setup_time > 0 and actor.gemstone != nil
      target.draw_box([x+5,y+27], [x+5+(actor.gem_setup_time/1000/5.0)*20.to_i,y+26], [0,0,255])
    end
  end
end

class Tower < Actor
  has_behaviors :graphical, :updatable,  :layered => {:layer => 2}
   
  attr_accessor :gemstone, :x, :y, :range, :gem_setup_time
  
  def setup 
    @itemsize = 32
    @gem_drawing_position = [@x+8, @y+8]
    
    
    @gemstone = nil
    @recharge_time = 1000 # ms
    x,y = get_center_pos
    @radius = spawn :tower_radius, :visible => false, :x => x, :y => y
    @gem_setup_time = 0
  end
  
  def show_radius
    @radius.radius = range
    @radius.show
  end
  
  def hide_radius
    @radius.hide
  end
  
  def self.build_cost
    100
  end
  
  def reset_recharge_time
    return if @gemstone == nil
    @recharge_time = @gemstone.recharge_time
  end
  
  def trigger_gem_setup_time
    @gem_setup_time = 5000.0 # hardcoded atm
  end
  
  def take_gem(gem)
    unless gem == nil
      gem.x = @x+8
      gem.y = @y+8
    end
    oldgem = @gemstone
    @gemstone = gem
    reset_recharge_time
    trigger_gem_setup_time
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
  
  def tick(last_tick_time, monsters)
    @recharge_time -= last_tick_time
    
    if @gem_setup_time > 0
      @gem_setup_time -= last_tick_time
    end
    
    if ready?
      return fire_at_monsters_in_range(monsters)
    end
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
    return false if @gem_setup_time > 0
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
        return fire!(monster)
      end 
    end    
  end
  
  def fire!(monster)
    reset_recharge_time
    x,y = get_center_pos
    particle = spawn :particle, :x => x, :y => y
    particle.damage = @gemstone.get_damage
    particle.color = @gemstone.get_color
    particle.monster = monster
    return particle
  end

  
end
