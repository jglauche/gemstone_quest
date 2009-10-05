class TowerBuilderView < ActorView
  
  
  
  def draw(target, x_off, y_off)
    return if not in_map_bounds?(@actor.mouse)
    begin_x, begin_y = pos_to_map_coordinates(@actor.mouse)
    begin_x, begin_y = map_to_pos_coordinates([begin_x, begin_y])
    target.draw_box([begin_x, begin_y], [begin_x+ITEMSIZE, begin_y+ITEMSIZE], [0,0,255])
  end
  
    
end

class TowerBuilder < Actor
  has_behaviors :layered => {:layer => 20}
   
  
  attr_accessor :mouse, :itemsize
  def setup
    @mouse = [0,0]
  end  
  
  def update_mouse_pos(pos)
    @mouse = pos
  end
  
  def get_build_position(pos)
    begin_x, begin_y = pos_to_map_coordinates(pos)
    begin_x, begin_y = map_to_pos_coordinates([begin_x, begin_y])
    return [begin_x, begin_y]
  end
  
  
end