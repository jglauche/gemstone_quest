class MonsterView < ActorView
  
  def draw(target, x_off, y_off)
    x = @actor.x + 8
    y = @actor.y + 8 
    monster = @mode.resource_manager.load_image "monster/monster1.png"
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
  
  attr_accessor :monster_type, :hitpoints, :max_hitpoints
  
  def setup
    # dummy stuff
    @monster_type = "monster1"
    @speed = 0.5
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
  
  def move(pathmap)
    return nil unless alive?
    # TODO: 
    # * find out the orientation we're headed to
    # * check if we would get off the path if we're continueing with the current speed
    # * if yes, change the origentation according to the path
    @x = @x + @speed # dummy
            
  end
  
  def take_damage(hp)
    @hitpoints -= hp
    if @hitpoints <= 0
      $mana.gain(@max_hitpoints/10)
    end
  end

end