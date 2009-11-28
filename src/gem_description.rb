class GemDescriptionView < ActorView
  def draw(target, off_x, off_y)  
    @font = stage.resource_manager.load_font 'FreeSans.ttf', 12
    return if @font.nil?
    @y_offset = 0
    
    render_font target,  "Gem " + actor.gem.gemtypes.map{|l| l.to_s}.join(",")
    render_font target, "Damage: #{fmt(actor.gem.min_damage)} - #{fmt(actor.gem.max_damage)}"  
    render_font target, "Saturation: #{fmt(actor.gem.saturation)}"  
    render_font target, "Recharge Time (ms): #{fmt(actor.gem.recharge_time)}"  
  end
  
  def render_font(target,str)
    text = @font.render str, true, [255,255,255]
    text.blit target.screen, [actor.x, actor.y+@y_offset]  
    @y_offset += 14
  end
  
  def fmt(val)
    sprintf("%0.2f",val)
  end
  
  
end

class GemDescription < Actor
  attr_accessor :x, :y, :gem
  
  has_behaviors :layered => {:layer => 7}
  
  
end
