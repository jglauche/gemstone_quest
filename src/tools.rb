

def get_distance(pos, monster_pos)
  x,y = pos    
  mx, my = monster_pos
  return Math.sqrt(((x-mx).abs)**2 + ((y-my).abs)**2) 
end

def in_bounds?(pos, startx, starty, offset_x, offset_y)
  x, y = pos
  
  if x >= startx and x < startx + offset_x
    if y >= starty and y < starty + offset_y
      return true
    end 
  end    
  return false
end

  def pos_to_map_coordinates(pos)
   return nil if ITEMSIZE == 0 
   ox, oy = MAP_OFFSET
   x, y = pos
   x = ((x-ox)/ITEMSIZE).to_i 
   y = ((y-oy)/ITEMSIZE).to_i
   [x,y]
  end
  
  def map_to_pos_coordinates(pos)
    ox, oy = MAP_OFFSET
    x, y = pos
    x = ox + x * ITEMSIZE
    y = oy + y * ITEMSIZE
    [x,y]
  end 
  
  def calculate_real_map_position(pos)
    map_to_pos_coordinates(pos_to_map_coordinates(pos))
  end
  

  def in_map_bounds?(mouse)
    ox, oy = MAP_OFFSET
    in_bounds?(mouse, ox, oy, ox+MAP_BLOCKS_X*ITEMSIZE, oy+MAP_BLOCKS_Y*ITEMSIZE)
  end
  
  def add_offset(pos, arr)
    x, y = pos
    arr.map{|a,b| [a+x, b+y]}
  end
  
  