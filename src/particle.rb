class ParticleView < ActorView
  def draw(target, x_off, y_off)
   # puts "drawing line from #{@position.inspect} to #{@monster.get_position.inspect}"
    #surface.draw_line(@position, @monster.get_position, @color)
    return unless @actor.alive
    color = @actor.color
    color[3] = 255
    
    target.screen.draw_circle_s([@actor.x, @actor.y], @actor.radius, color)
  end
  
end

class Particle < Actor
  has_behaviors :layered => {:layer => 6}
   
  attr_accessor :monster, :damage, :color, :radius, :alive
  
  def setup
    @radius = 3
    @speed = 12
    @alive = true
  end
   

  def update
    return unless @alive

    mx, my = @monster.get_center_pos
    if get_distance([@x,@y], [mx,my]) < 10 
      @monster.take_damage(@damage)
      @alive = false
    end 
    
    dx = (mx-@x).to_f
    dy = (my-@y).to_f
    
    v = (dx.abs+dy.abs)/@speed
    
    @x += dx / v
    @y += dy / v    
  end
  
   
  
end