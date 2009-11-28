class GemstoneView < ActorView
  def draw(target, x, y)
    position = [actor.x, actor.y]
    gem =  stage.resource_manager.load_image "gem.png"
    gem.blit(target.screen,position) 

    polygons.each do |poly|
      target.draw_polygon(add_offset(position, poly), actor.get_color)
    end
    #target.screen.draw_box_s(position,[x+15,y+15], get_color)
  end

  def polygons
    @polygon_array ||=
    [
      [[3,3],[5,3],[5,2],[6,2]],
      [[7,3],[12,3],[8,2],[10,2],[8,1]],
      [[6,11],[6,8],[4,8],[4,5],[2,5],[5,5],[5,10],[5,7],[3,7],[3,6]],
      [[13,5],[8,5],[8,13]], 
      [[9,11],[9,6],[12,6],[12,7],[11,7],[11,8],[10,8],[10,10],[10,7],[11,7],[7,7],[7,5]]
    ]
  end

end

class Gemstone < Actor
  has_behaviors :updatable, :layered => {:layer => 3}


  attr_accessor :range, :sender, :gemtypes, :min_damage, :max_damage, :recharge_time, 
                :special_modificator, :saturation


  def setup
    @special_modificator = 1
    @gemtypes = [self.class.to_s]
    @description = spawn :gem_description, :visible => false
    @description.hide
    @description.gem = self
  end

  def self.choose_gem_to_create
    #   arr = [:amethyst, :ruby, :azurite, :malachite, :diamond].shuffle!
    arr = [:amethyst, :ruby, :azurite, :malachite, :diamond]
    arr[rand(arr.size)]
  end  
  
  def combine(othergem)
    if self.class == othergem.class and @gemtypes.size == 1 and othergem.gemtypes.size == 1
      combine_pure(othergem)
    else
      combine_unpure(othergem)
    end

    if @recharge_time < 50
      @recharge_time = 50
    end

  end
  
  
  # when combining two gems, calculate the resulting damage like this:
  # damage of better gem * 100 + damage of the other gem * pct
  def add_dmg_pct(dmg1, dmg2, pct)
    if dmg1 > dmg2
      return dmg1 + dmg2.to_f * pct/100
    else
      return dmg2 + dmg1.to_f * pct/100
    end   
  end
  
  # combine pure gems:
  # gives great damage bonus, gives great special bonus
  # increases saturation (incrased saturatin = better armor penetration later)
  def combine_pure(othergem)
    
    @min_damage = add_dmg_pct(@min_damage, othergem.min_damage, 55)
    @max_damage = add_dmg_pct(@max_damage, othergem.max_damage, 85)
    
    @recharge_time = (@recharge_time + othergem.recharge_time) / 2.08
    @range = (@range + othergem.range) / 1.96    
 
 #   @special_modificator += 0.2
    @saturation = (@saturation + othergem.saturation) / 1.9
  end

  # combine unpure gems:
  # gives moderate damage bonus, good recharge & range bonus
  # specials will have lower effects
  def combine_unpure(othergem)
    @min_damage = add_dmg_pct(@min_damage, othergem.min_damage, 35)
    @max_damage = add_dmg_pct(@max_damage, othergem.max_damage, 65)

    @recharge_time = (@recharge_time + othergem.recharge_time) / 2.12
    @range = (@range + othergem.range) / 1.92 
  #  @special_modificator += 0.01
    @gemtypes += othergem.gemtypes
    @gemtypes.uniq!
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
  
  def show_description(x,y)
    @description.x = x
    @description.y = y
#    @description.gem_type = self.class
#    @description.subtypes = @subtypes
    @description.show
  end
  
  def hide_description
    @description.hide
  end


end
