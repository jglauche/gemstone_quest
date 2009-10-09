class TrackCreator < Actor
  
  def setup
    @dirs = []
    @types = []
  end
  
  def create_tracks(path)
    for i in (0..path.size)
      dir = get_origentation(path[i], path[i+1])
      track_type = nil
      case dir
        when :right, :left
          track_type = :horizontal
        when :up, :down        
          track_type = :vertical
      end
      unless track_type == nil
        # looks like it can be made DRYer. but it works for now
        if @dirs.last == :right and dir == :up
            track_type = :turn_left_up
        elsif @dirs.last == :right and dir == :down
            track_type = :turn_left_down
        end
        
        if @dirs.last == :left and dir == :up
            track_type = :turn_up_right
        elsif @dirs.last == :left and dir == :down
            track_type = :turn_down_right
        end

        if @dirs.last == :up and dir == :left
            track_type = :turn_left_down
        elsif @dirs.last == :up and dir == :right
            track_type = :turn_down_right
        end

        if @dirs.last == :down and dir == :left
            track_type = :turn_left_up
        elsif @dirs.last == :down and dir == :right
            track_type = :turn_up_right
        end

              
        create_track!(path[i], track_type)
      end
      @types << track_type
      @dirs << dir
      
    end
  end
  
  def create_track!(pos, action)
    track = spawn :track 
    track.x, track.y = map_to_pos_coordinates(pos)
    track.action = action  
  end
  
end