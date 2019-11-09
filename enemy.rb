class Enemy
  attr_reader :x, :y, :radius
  
  def initialize(window)
    @radius = 20
    @x = rand(window.width - 2 * @radius) + @radius
    @y = 0
    @image = Gosu::Image.new('images/enemy.png')
    @speed = rand(1..6)
  end
  
  def move
    @y += @speed
  end
  
  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end
end