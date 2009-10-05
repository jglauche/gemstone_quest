#!/usr/bin/env ruby

f = Dir.glob("*.png")
f.each do |file|
  system("convert -scale 32x32 #{file} 32px/#{file}")
end