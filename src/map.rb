class MapView < ActorView
   def draw(target, x_offset, y_offset)
    ox, oy = @actor.map_offset
    i = 0
    f = 0

    #background
    @actor.blocks_x.times do 
      @actor.blocks_y.times do 
        if item = @actor.map_items[{i,f}]
          if item.kind_of? Tower
            item = :tower
          end
        else      
          item = :grass
        end
        asset = @mode.resource_manager.load_image item.to_s + ".png"
        
        
         asset.blit(target.screen,[ox+i*@actor.itemsize,oy+f*@actor.itemsize])   
        f += 1
      end
      f = 0
      i += 1
    end
    
#    if @tower_build_mode and in_map_bounds?
#      begin_x, begin_y = pos_to_map_coordinates(@mouse)
#      begin_x, begin_y = map_to_pos_coordinates([begin_x, begin_y])
#      
#      surface.draw_box([begin_x, begin_y], [begin_x+@itemsize, begin_y+@itemsize], [0,0,255])
#    end	
#    
#    # monsters
#    @monsters = @monsters.delete_if{|m| !m.alive?}
#    @monsters.each do |m|
#      m.draw(surface) 
#    end
#    
#    # towers & gemsy
#    
#    @towers.each do |tower|
#      tower.draw(surface)
#      if tower.hovered?(@mouse) # tower hovered? -> show radius
#        tower.draw_radius(surface)
#        $force_redraw_background = true
#      end
#    end    
#       
#    # particles 
#    $particles.each do |p|
#	   p.draw(surface)
#	end     
#  
  end
  
end

class Map < Actor
 
  has_behaviors :updatable,  :layered => {:layer => 1}
  
  
  attr_accessor :mouse, :towers
  attr_accessor :map_offset, :blocks_x, :blocks_y, :map_items, :itemsize
  
  def setup
    spawn_x,spawn_y = [0,3]
    @map_items = {}
    @blocks_x = MAP_BLOCKS_X
    @blocks_y = MAP_BLOCKS_Y
    @itemsize = 32 # pixel
    @changed = true
    
    @map_offset = [20,20]

    @monsters = []
    @monster_spawn_point = [@map_offset[0]+spawn_x*@itemsize,@map_offset[1]+spawn_y*@itemsize+@itemsize/4]
    @mouse = [0,0]
    @towers = []
    
    
    reset_mode
  end
  
  def set_mouse_pos(pos)
    @mouse = pos
  end

  def mouse_click(pos)
    if in_map_bounds? 
      if @tower_build_mode and can_build_tower_here?(pos)
        return build_tower!(pos)
      end
      if obj = get_accepting_object_if_hovered
        unless obj.magic_gem == nil
          return obj.magic_gem.drag_gem(obj)
        end
      end
    end
  end
  
  def get_accepting_object_if_hovered
     return nil if not in_map_bounds?
     
     @towers.each do |tower|
      if tower.hovered?(@mouse)
        return tower
      end
    end	
    return nil
  end
  
  def can_build_tower_here?(pos)
    x,y = pos_to_map_coordinates(pos)
    if @map_items[{x,y}] == nil
      return true
    end    
  end
  
  def build_tower!(pos)
    return if $mana.take(Tower.build_cost) == nil
    x,y = pos_to_map_coordinates(pos)
    tower = Tower.new(map_to_pos_coordinates([x,y]))
    @towers << tower
    add_item(x,y,tower)
    reset_mode
  end
  
  def reset_mode
    @tower_build_mode = false
  end
  
  def enable_tower_build_mode
   # if $mana.has?(Tower.build_cost)
      @tower_build_mode = true
   # end
  end
  
   
  def add_item(x,y,item)
    @map_items[{x,y}] = item
  end
  
  def spawn_monster(type, hitpoints, speed)
    x,y = @monster_spawn_point
    m = Monster.new(type, hitpoints, speed)
    m.spawn(x,y,nil)
    @monsters << m
    @changed = true
  end 
  
  def update_monsters
    @monsters.each do |m|
      if m.alive?
        m.move
        @changed = true
      else
        m = nil
      end
    end
  end
    
  def fire_towers(last_tick_time)
    @towers.each do |tower|
      tower.tick_time(last_tick_time)
      if tower.ready? 
        tower.fire_at_monsters_in_range(@monsters)
      end
    end
  end
 


    

   
end

