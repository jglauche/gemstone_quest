class GemstoneView < ActorView
  def draw(target, x, y)
    position = [@actor.x, @actor.y]
    gem =  @mode.resource_manager.load_image "gem.png"
    gem.blit(target.screen,position) 

    polygons.each do |poly|
      target.draw_polygon(add_offset(position, poly), @actor.get_color)
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


  attr_accessor :range, :sender, :subtypes, :min_damage, :max_damage, :recharge_time, 
                :special_modificator, :saturation


  def setup
    @special_modificator = 1
    @subtypes = []
  end

  def self.choose_gem_to_create
    #   arr = [:amethyst, :ruby, :azurite, :malachite, :diamond].shuffle!
    arr = [:amethyst, :ruby, :azurite, :malachite, :diamond]
    arr[rand(arr.size)]
  end  
  
  def combine(othergem)
    if self.class == othergem.class and (@subtypes == nil or @subtypes.size == 0)
      combine_pure(othergem)
    else
      combine_unpure(othergem)
    end

    if @recharge_time < 50
      @recharge_time = 50
    end

  end
  
  
  # combine pure gems:
  # gives great damage bonus, gives great special bonus
  # increases saturation (incrased saturatin = better armor penetration later)
  def combine_pure(othergem)
    @min_damage += othergem.min_damage / 2.0
    @max_damage += othergem.max_damage / 1.5
    @recharge_time = (@recharge_time + othergem.recharge_time) / 2.02
    @range = (@range + othergem.range) / 1.97    
    @special_modificator += 0.2
    @saturation = (@saturation + othergem.saturation) / 1.9
  end

  # combine unpure gems:
  # gives moderate damage bonus, good recharge & range bonus
  # specials will have lower effects
  def combine_unpure(othergem)
    @min_damage = othergem.min_damage / 8.0
    @max_damage += othergem.max_damage / 2.0
    @recharge_time = (@recharge_time + othergem.recharge_time) / 2.04
    @range = (@range + othergem.range) / 1.92 
    @special_modificator += 0.01
    @subtypes << othergem.class
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
