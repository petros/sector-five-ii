require 'gosu'

class Sprite
  attr_reader :x, :y, :radius

  def initialize
  end
  
  def collides_with?(sprite)
    distance = Gosu.distance(x, y, sprite.x, sprite.y)
    return distance < @radius + sprite.radius
  end
  
end