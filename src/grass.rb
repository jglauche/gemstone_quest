class GrassView < ActorView
   # a lot faster than creating 384 single grass actors

   def draw(target, x_offset, y_offset)
    ox, oy = @actor.map_offset
    i = 0
    f = 0
    asset = @mode.resource_manager.load_image "grass.png"
        
    @actor.map_blocks_x.times do 
      @actor.map_blocks_y.times do 
        asset.blit(target.screen,[ox+i*@actor.itemsize,oy+f*@actor.itemsize])   
        f += 1
      end
      f = 0
      i += 1
    end
  end
  
end


class Grass < Actor
    
    has_behaviors :layered => {:layer => 1}
    attr_accessor :map_offset, :map_blocks_x, :map_blocks_y, :map_items, :itemsize
   
   
   def setup 
    @map_offset = [20,20]
    @map_blocks_x = MAP_BLOCKS_X
    @map_blocks_y = MAP_BLOCKS_Y 
    @itemsize = ITEMSIZE
  end
end