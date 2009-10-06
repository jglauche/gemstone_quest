# WIP
class Bullet < Actor
  
  def setup
     # (center, monster, damage, color)
    @position = center
    @monster = monster
    @damage = damage
    @color = color 
    @color[3] = 255
    @radius = 3
    @speed = 12
    @destroyed = false
  end
   
  def draw(surface)
   # puts "drawing line from #{@position.inspect} to #{@monster.get_position.inspect}"
    #surface.draw_line(@position, @monster.get_position, @color)
    return if @destroyed
    surface.draw_circle_s(@position, @radius, @color)
  end
  
  def update
    return if @destroyed
    x, y = @position
    mx, my = @monster.get_center_pos
    if get_distance(@position, [mx,my]) < 10 
      @monster.take_damage(@damage)
      @destroyed = true
    end 
    
    dx = (mx-x).to_f
    dy = (my-y).to_f
    
    v = (dx.abs+dy.abs)/@speed
    
    x += dx / v
    y += dy / v
    
    @position = [x,y]
  end
  
   
  # should be externalized
  def self.fire_particle(center, monster, damage, color)
    p = Particle.new(center, monster, damage, color)
    $particles << p
  end
  
end