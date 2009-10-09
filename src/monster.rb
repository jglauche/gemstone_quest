class MonsterView < ActorView
  
  def draw(target, x_off, y_off)
    return unless @actor.alive?
    x = @actor.x + 8
    y = @actor.y + 8 
    monster = @mode.resource_manager.load_image "monster/monster1.png"
    
    # std monster origentation should be :right
    rot = 0
    case @actor.orientation 
      when :down  
        rot = -90
      when :up
        rot = 90
      when :left
        rot = 180
    end   
    if rot != 0
      monster = monster.rotozoom(rot, 1)       
    end
    
    monster.blit(target.screen,[x,y])  
    
    # health bar
    if @actor.max_hitpoints > 0
      hp = 15 * @actor.hitpoints / @actor.max_hitpoints
      if hp > 10 
        color = [0,255,0]
      elsif hp > 5
        color = [255,255,0]
      else
        color = color = [255,0,0]
      end

      target.draw_box([x,y-3], [x+hp,y-2], color)
    end
  end
end 

class Monster < Actor
  
  has_behaviors :layered => {:layer => 5}
  
  attr_accessor :monster_type, :hitpoints, :max_hitpoints, :orientation
  
  def setup
    # dummy stuff
    @monster_type = "monster1"
    @speed = 1
    @hitpoints = 20
    @max_hitpoints = 20
    
  end
  
  def alive?
    true if @hitpoints > 0
  end
    
  def get_position
    [@x,@y]
  end

  def get_center_pos
    x,y = @x, @y
    x += 8  
    y += 8
    [x,y]
  end
  
  def move(path)
    return nil unless alive?
    # first move?
    unless @pathitem 
      @pathitem = 0           
      @orientation = find_out_origentation(path)
     # puts "new origentation is #{@orientation.inspect}"
    end
    

    x, y = simulate_movement
    # TODO: fix the calculation if we're moving onto a new map tile
    # the current implementation does only allow a limited speed choice
    mod_x = (x-MAP_OFFSET[0]) % ITEMSIZE 
    mod_y = (y-MAP_OFFSET[1]) % ITEMSIZE
#    puts "modx/y: #{mod_x} , #{mod_y}"
    if ((@orientation == :right or @orientation == :left) and mod_x == 0) or
       ((@orientation == :up or @orientation == :down) and mod_y == 0)
      @pathitem += 1
      @orientation = find_out_origentation(path)        
      x, y = simulate_movement
   #   puts "new origentation is #{@orientation.inspect}"
    end
    @x = x
    @y = y
  end
  
  def find_out_origentation(path)
    pos1 = path[@pathitem]
    pos2 = path[@pathitem+1]
    return @origentation if pos1 == nil or pos2 == nil
    x1, y1 = pos1
    x2, y2 = pos2
    #puts "moving from #{x1},#{y1} to #{x2},#{y2}"
    if x1 > x2
      return :left  
    elsif x2 > x1
      return :right
    elsif y1 > y2
       return :up
    else
       return :down
   end
  end
  
  def simulate_movement
    x = @x
    y = @y
    case @orientation
      when :right    
          x = @x + @speed
      when :left
          x = @x - @speed
      when :up
          y = @y - @speed
      when :down 
          y = @y + @speed
    end
    return [x,y]
  end
  
  def take_damage(hp)
    @hitpoints -= hp
  end

end