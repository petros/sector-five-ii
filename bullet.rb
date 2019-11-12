# frozen_string_literal: true

require_relative 'sprite'

# Bullet
class Bullet < Sprite
  SPEED = 5

  def initialize(window, x_pos, y_pos, angle)
    @x = x_pos
    @y = y_pos
    @direction = angle
    @image = Gosu::Image.new('images/bullet.png')
    @radius = 3
    @window = window
  end

  def move
    @x += Gosu.offset_x(@direction, SPEED)
    @y += Gosu.offset_y(@direction, SPEED)
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end

  def onscreen?
    right = @window.width + @radius
    left = -@radius
    top = -@radius
    bottom = @window.height + @radius
    @x > left && @x < right && @y > top && @y < bottom
  end
end
