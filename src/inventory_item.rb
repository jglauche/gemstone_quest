class InventoryItemView < ActorView
  def draw(target, off_x, off_y)
    color = [200,200,200]
    
    target.draw_box([@actor.x,@actor.y], [@actor.x+24,@actor.y+24],  color)
#    unless item == nil or item.magic_gem == nil
#      item.magic_gem.draw(surface, [@inventory.offset_x+x*24+4,@inventory.offset_y+y*24+4])
#    end
  
  end    
end


class InventoryItem < Actor
  has_behaviors :updatable, :layered => {:layer => 2}
    
  attr_accessor :gemstone, :x, :y
  
  def setup
    @gemstone = nil
  end 
  
  
  
  def take_gem(newgem)
    newgem.x = @x+4
    newgem.y = @y+4
  #  puts "at #{@pos.inspect} got a gem, have: #{@magic_gem.inspect}"
    give_gem = nil
    unless @gemstone == nil
   #   puts "but already have one"
      give_gem = @gemstone
    end
    @gemstone = newgem
    
    return give_gem    
  end
  
end