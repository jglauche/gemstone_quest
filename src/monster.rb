class Monster < Actor
  
  has_behaviors :animated, :layered => {:layer => 5}
  
  def setup
    # dummy stuff
    @speed = 0.5
    @hitpoints = 20
    @max_hitpoints = 20
  end
  
  def alive?
    true if @hitpoints > 0
  end
  
  def spawn(x,y,route)
    @x = x
    @y = y  
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
  
  def move
    if alive?
      @x = @x + @speed # dummy
    end
    
  end
  
  def take_damage(hp)
    @hitpoints -= hp
    if @hitpoints <= 0
      $mana.gain(@max_hitpoints/10)
    end
    #puts "ouch! got hit by #{hp} - HP remaining: #{@hitpoints}"
  end

#  def draw(surface)
#    @asset.blit(surface,[@x,@y])  
#    
#    
#    
#    if @max_hitpoints > 0
#      hp = 15 * @hitpoints / @max_hitpoints
#      if hp > 10 
#        color = [0,255,0]
#      elsif hp > 5
#        color = [255,255,0]
#      else
#        color = color = [255,0,0]
#      end
#
#      surface.draw_box([@x,@y-3], [@x+hp,@y-2], color)
#    end
#  end

end