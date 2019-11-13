# frozen_string_literal: true

require_relative 'sprite'

# Player
class Player < Sprite
  ROTATION_SPEED = 3
  ACCELERATION = 2
  FRICTION = 0.9

  attr_reader :angle

  def initialize(window)
    @x = 200
    @y = 200
    @angle = 0
    @image = Gosu::Image.new('images/ship.png')
    @velocity_x = 0
    @velocity_y = 0
    @radius = 20
    @window = window
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def turn_right
    @angle += ROTATION_SPEED
  end

  def turn_left
    @angle -= ROTATION_SPEED
  end

  def accelerate
    @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= FRICTION
    @velocity_y *= FRICTION
    not_move_beyond_right_boundary
    not_move_beyond_left_boundary
    not_move_beyond_bottom_boundary
  end

  def off_top?
    y < radius
  end

  private

  def not_move_beyond_right_boundary
    return unless @x > @window.width - @radius

    @velocity_x = 0
    @x = @window.width - @radius
  end

  def not_move_beyond_left_boundary
    return unless @x < @radius

    @velocity_x = 0
    @x = @radius
  end

  def not_move_beyond_bottom_boundary
    return unless @y > @window.height - @radius

    @velocity_y = 0
    @y = @window.height - @radius
  end
end
