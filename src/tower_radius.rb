class TowerRadiusView < ActorView
   def draw(target, off_x, off_y)  
    target.draw_circle_a([@actor.x, @actor.y], @actor.radius.to_i, [255,255,255,150])
  end
end

class TowerRadius < Actor
  attr_accessor :x, :y, :radius, :alive
  
  has_behaviors :layered => {:layer => 4}
  
  
end
