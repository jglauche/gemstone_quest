class Wave < Actor
    
   attr_accessor :start_coordinates
    
  
  def setup
    @monster_queue = []  
    @next_monster_time = 500
    @next_wave_time = 15000
    @monster_timer = 800
    @wave_timer = 20000
    @wave_number = 0
  end
  
  def tick(time)
    monster = nil
    @next_monster_time -= time
    if @next_monster_time <= 0
      monster = spawn_monster!
      @next_monster_time = @monster_timer
    end
    @next_wave_time -= time
    if @next_wave_time <= 0
      spawn_wave!
      @next_wave_time = @wave_timer
    end
    
    return monster
  end
  
  def spawn_wave!
    @wave_number+=1

    
    case @wave_number
      when 1
        5.times do
          @monster_queue << [:monster1, 20, 1]
        end
      when 2
        15.times do
          @monster_queue << [:monster1, 10, 2]
        end
      when 3
        6.times do
          @monster_queue << [:monster1, 70, 0.5]
        end
      when 4
        3.times do
          @monster_queue << [:monster1, 100, 0.25]
        end
      when 5
        30.times do
          @monster_queue << [:monster1, 30, 1]
        end
      when 6
        3.times do
          @monster_queue << [:monster1, 400, 0.25]
        end
      else
       10.times do
          @monster_queue << [:monster1, 100, 0.5]
       end
     end
  end
  
  def spawn_monster!
    return if @monster_queue == []
    monster_type, hitpoints, speed = @monster_queue.delete_at(0)
    
    monster = spawn :monster
    monster.x, monster.y = map_to_pos_coordinates(@start_coordinates)
    monster.monster_type = monster_type
    monster.speed = speed
    monster.set_hitpoints(hitpoints)
    
    
    return monster    
  end
  
  
  
end