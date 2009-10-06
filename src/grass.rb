class Grass < Actor
    
    has_behaviors :layered => {:layer => 1}, :graphical=>{
      :tiled=>true,
      :num_x_tiles=>MAP_BLOCKS_X,
      :num_y_tiles=>MAP_BLOCKS_Y}

    attr_accessor :map_items, :itemsize
   
   
   def setup 
    @itemsize = ITEMSIZE
  end
end
