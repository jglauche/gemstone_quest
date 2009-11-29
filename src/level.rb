class Level < Actor
  
  attr_accessor :monster_path
  attr_accessor :waves
  
  def setup
    @monster_path = []
  end
  
  def load(levelnum)
    path = "data/levels/#{levelnum.to_i}/"
    ["path.txt"].each do |file|
      return false unless File.exists?(path+file)
    end
    load_monster_path!(path+"path.txt")
    
    
    true
  end
  
  def load_monster_path!(filename)
    f = File.open(filename)
    contents = f.readlines
    f.close
    
    contents.each do |line|
      x, y = line.split(",")
      @monster_path << [x.to_i, y.to_i]
    end
            
  end
  
  
end