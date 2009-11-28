class MonsterView < ActorView
  
  def draw(target, x_off, y_off)
    return unless actor.alive?
    x = actor.x + 8
    y = actor.y + 8 
    monster = stage.resource_manager.load_image "monster/monster1.png"
    
    # std monster origentation should be :right
    rot = 0
    case actor.orientation 
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
    if actor.max_hitpoints > 0
      hp = 15 * actor.hitpoints / actor.max_hitpoints
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
  
  attr_accessor :monster_type, :hitpoints, :max_hitpoints, :orientation, :speed
  
  def setup
    # dummy stuff
    @monster_type = "monster1"
    @speed = 1
    @hitpoints = 20
    @max_hitpoints = 20
    @tilepos  = [0,0]
  end
  
  def alive?
    true if @hitpoints > 0
  end
  
  def set_hitpoints(hp)
    @hitpoints = hp
    @max_hitpoints = hp
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
      @tilepos = [0,0]
     end
    

    @tilepos = simulate_movement(@tilepos)

    if @tilepos[0] > 32 or @tilepos[1] > 32 or @tilepos[0] < -32 or @tilepos[1] < -32
      case @orientation 
        when :right
          @tilepos[0] -= 32
        when :left
          @tilepos[0] += 32
        when :up
          @tilepos[1] += 32
        when :down
          @tilepos[1] -= 32
      end
      #@tilepos = [0,0]
      @pathitem += 1
      @orientation = find_out_origentation(path)      
    end
    @x, @y = simulate_movement([@x,@y])
  end
  
  def find_out_origentation(path)
    pos1 = path[@pathitem]
    pos2 = path[@pathitem+1]
    return @origentation if pos1 == nil or pos2 == nil
    get_origentation(pos1, pos2) # tools.rb
  end
  
  def simulate_movement(pos)
    x, y = pos
    case @orientation
      when :right    
          x = x + @speed
      when :left
          x = x - @speed
      when :up
          y = y - @speed
      when :down 
          y = y + @speed
    end
    return [x,y]
  end
  
  def take_damage(hp)
    @hitpoints -= hp
  end

end
