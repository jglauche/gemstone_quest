class ManaView < ActorView
  def draw(target, x_off, y_off)
    font = @mode.resource_manager.load_font 'FreeSans.ttf', 12
    return if font.nil?
    
    str = "Mana: #{sprintf('%0.1f',@actor.mana)} / #{@actor.max_mana}"
    
    24 - str.size.times do 
      str << " "
    end 
 
    text = font.render str, true, [255,255,255] #, [0,0,0]
    text.blit target.screen, [@actor.x, @actor.y]
  end
end

class Mana < Actor
  has_behaviors :layered => {:layer => 2}
  attr_accessor :mana, :max_mana
  
  def setup
    @mana = 1000
    @max_mana = 2000    
    
    @mana_gain_time = 100
    @mana_gain_pct = 0.01
    @recharge_time = @mana_gain_time
    
    @towers_built = 0
  end
   
  def tower_cost
    200 * (1 + 0.1 * @towers_built)
  end
  
  def gem_cost
    25
  end 
   
  def has?(num)
    return true if num <= @mana
    false
  end  
    
  def take(num)
    if @mana < num
      return nil
    end
    @mana -= num
    return true
  end
  
  def gain(num)
    @mana += num
    if @mana > @max_mana
      @mana = @max_mana
    end
  end
  
  def tick(last_tick_time)
    @recharge_time -= last_tick_time
    if @recharge_time <= 0
      @recharge_time = @mana_gain_time
      gain(@max_mana * @mana_gain_pct/100)
    end
  end
  
end
