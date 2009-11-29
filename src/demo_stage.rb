require 'stage'
require 'ftor'
require "gemstone"
require "tower"
require "particle"
class DemoStage < Stage
  def setup
    super
    create_actor :background

    @mana = create_actor :mana, :x => 650, :y => 0


    @grass_land = create_actor :grass, :x => 20, :y => 20
    @inv = {}

    @inventory_offset_x = 820
    @inventory_offset_y = 65    
    @inventory_x = 8
    @inventory_y = 20

    @inventory_x.times do |x|
      @inventory_y.times do |y|
        @inv[[x,y]] = create_actor(:inventory_item, :x => @inventory_offset_x+x*24, :y => @inventory_offset_y+y*24)
      end
    end

    @dragged_gem = nil
    @buildmode = nil

    @towers = []  
    @monsters = []
    @particles = []

    @level = create_actor :level
    unless @level.load(1) # TODO: GUI for selecting the level
      puts "could not load level."
    end
    track_creator = create_actor :track_creator
    track_creator.create_tracks(@level.monster_path)

    @wave = create_actor :wave
    @wave.start_coordinates = @level.monster_path.first


    reset_hooks  

  end

  # for map positions only
  def object_on_this_position?(x,y)
    @towers.map{|t| [t.x,t.y] == [x,y]}.include? true or @level.monster_path.include?(pos_to_map_coordinates([x,y]))   
  end

  def get_gem_accepting_object_on_this_position(pos)
    grid_pos = calculate_real_map_position(pos)
    @towers.each do |tower|
      if grid_pos == [tower.x, tower.y]
        return tower
      end
    end 
    nil
  end

  def reset_hooks
    input_manager.clear_hooks 
    @combine_mode = false

    input_manager.reg KeyDownEvent, K_2 do
      tower_building_mode()
    end  

    input_manager.reg KeyDownEvent, K_T do
      tower_building_mode()
    end  


    input_manager.reg KeyDownEvent, K_C do
      if @mana.has?(@mana.gem_cost) and not inventory_full?
        create_gem
      end
    end

    input_manager.reg KeyDownEvent, K_N do
      @wave.spawn_wave!
    end

    input_manager.reg KeyDownEvent, K_M do
      @mana.upgrade_mana
    end

    input_manager.reg KeyDownEvent, K_G do
      @combine_mode = true
    end    

    input_manager.reg MouseDownEvent do |ev|
      x,y = ev.pos          
      item = check_if_inventory_item_is_triggered([x,y]) || get_gem_accepting_object_on_this_position(ev.pos)
      unless item == nil or item.gemstone == nil
        @dragged_gem = item.gemstone.drag_gem(item)
        toggle_drag_gem_mode
      end
    end

    input_manager.reg MouseMotionEvent do |ev|
      if @active_tower
        @active_tower = @active_tower.hide_radius
        @active_tower = nil
      end

      if @active_gemstone
        @active_gemstone.hide_description
        @active_gemstone = nil
      end

      if item = check_if_inventory_item_is_triggered(ev.pos) || get_gem_accepting_object_on_this_position(ev.pos)
        if item.class == Tower and item.gemstone != nil
          @active_tower = item
          item.show_radius
        end
        if item.gemstone != nil 
          @active_gemstone = item.gemstone
          @active_gemstone.show_description(50,550)
        end        
      end
    end 

  end

  def toggle_drag_gem_mode
    input_manager.reg MouseMotionEvent do |ev|
      @dragged_gem.set_pos(ev.pos)
    end  
    input_manager.reg MouseUpEvent do |ev|
      item = nil
      # inventory?
      taking_item = check_if_inventory_item_is_triggered(ev.pos)
      if taking_item == nil # something on the map accepting this gem?
        taking_item = get_gem_accepting_object_on_this_position(ev.pos) # might be still nil
      end

      if @combine_mode and taking_item and taking_item.gemstone
        # get gem from taking item, will be taken on next if
        gem = taking_item.take_gem(nil)
        @dragged_gem.combine(gem) # gem.combine(@dragged_gem)
        gem.hide()
        gem = nil
        @combine_mode = false
      end

      if taking_item
        item = taking_item.take_gem(@dragged_gem)
        if item
          item.sender = @dragged_gem.sender
          @dragged_gem.sender = nil
          item.return_to_sender
        end
      else
        @dragged_gem.return_to_sender
      end


      reset_hooks
    end

  end

  def tower_building_mode
    unless @building_tower
      @building_tower = true
      if @mana.has?(@mana.tower_cost)

        # TODO don't create this everytime, use @buildmode.show/hide
        # and @buildmode.is/is_no_longer(:updatable)
        @buildmode = create_actor(:tower_builder)
        input_manager.reg MouseMotionEvent do |ev|
          @buildmode.update_mouse_pos ev.pos
        end

        input_manager.reg MouseDownEvent do |ev|
          unless @buildmode.nil?
            x,y = @buildmode.get_build_position ev.pos          
            unless object_on_this_position?(x,y)
              if @mana.take(@mana.tower_cost)
                @towers << create_actor(:tower, :x => x, :y => y)
              end
            end
            disable_building_mode
          end
        end

        input_manager.reg KeyDownEvent, K_ESCAPE do
          disable_building_mode
        end
      end
    end
  end

  def disable_building_mode
    reset_hooks
    unless @buildmode == nil 
      @buildmode.update_mouse_pos [-1,-1] # that forces to undraw it.
    end
    @buildmode = nil
    @building_tower = false
  end

  def update(time)
    # Mana gain
    @mana.tick(time)
    # monster spawn
    new_monster = @wave.tick(time)
    if new_monster
      @monsters << new_monster
    end

    # Monster move
    @monsters.map{|l| l.move(@level.monster_path)}
    # towers recharge & "collect" their shots fired
    ret = @towers.map{|l| l.tick(time, @monsters)}
    ret.each do |r|
      if r.kind_of? Particle
        @particles << r         
      end
    end 

    # update particles
    @particles.map{|p| p.update}
    @particles = @particles.delete_if{|p| !p.alive}


    # gain mana for dead monsters and remove them from the list
    @monsters.each do |m| 
      unless m.alive? 
        @mana.gain(m.max_hitpoints)
      end
    end
    @monsters = @monsters.delete_if{|m| !m.alive?}
  end

  # inventory stuff
  def inventory_full?
    @inv.each do |pos,inv|
      if inv.gemstone == nil
        return false
      end 
    end
    true
  end 

  def get_first_empty_inventory_slot
    @inventory_y.times do |y|
      @inventory_x.times do |x|
        item = @inv[[x,y]] 
        return item if item.gemstone == nil
      end
    end
  end

  def check_if_inventory_item_is_triggered(pos)
    @inventory_x.times do |x| 
      @inventory_y.times do |y| 
        if in_bounds?(pos, @inventory_offset_x+x*24, @inventory_offset_y+y*24,24,24)
          return @inv[[x,y]]
        end
      end
    end
    return nil
  end

  def create_gem
    return if inventory_full?
    return if @mana.take(@mana.gem_cost) == nil
    slot = get_first_empty_inventory_slot              
    slot.gemstone = create_actor(Gemstone.choose_gem_to_create, :view => GemstoneView, :x => slot.x+4, :y => slot.y+4)
  end

end

