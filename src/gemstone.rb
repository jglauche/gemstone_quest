class GemstoneView < ActorView
  def draw(target, x, y)
     position = [@actor.x, @actor.y]
     gem =  @mode.resource_manager.load_image "gem.png"
     gem.blit(target.screen,position) 

    target.draw_polygon(add_offset(position, [[3,3],[5,3],[5,2],[6,2]]), @actor.get_color)
    target.draw_polygon(add_offset(position, [[7,3],[12,3],[8,2],[10,2],[8,1]]), @actor.get_color)
    target.draw_polygon(add_offset(position, [[6,11],[6,8],[4,8],[4,5],[2,5],[5,5],[5,10],[5,7],[3,7],[3,6]]), @actor.get_color)
    

    target.draw_polygon(add_offset(position, [[13,5],[8,5],[8,13]]), @actor.get_color)
    target.draw_polygon(add_offset(position, [[9,11],[9,6],[12,6],[12,7],[11,7],[11,8],[10,8],[10,10],[10,7],[11,7],[7,7],[7,5]]), @actor.get_color)
    
    #target.screen.draw_box_s(position,[x+15,y+15], get_color)
  end
  
end

class Gemstone < Actor
  has_behaviors :updatable, :layered => {:layer => 3}
   
  
  attr_accessor :range
  attr_accessor :sender
  
  
  def self.choose_gem_to_create
    #   arr = [:amethyst, :ruby, :azurite, :malachite, :diamond].shuffle!
    arr = [:amethyst, :ruby, :azurite, :malachite, :diamond]
    arr[rand(arr.size)]
  end  
  
  def recharge_time
    @recharge_time
  end
    
  def get_color
    @color + [@saturation]
  end
  
  def get_damage
    return @min_damage + rand(@max_damage)
  end
    
    
  def set_pos(pos)
    @x, @y = pos
  end
    
  def drag_gem(sender)
    @sender = sender
    sender.gemstone = nil
    return self
  end
  
  def return_to_sender
    @sender.take_gem(self)
    @sender = nil
  end 
    
  
  
end