# frozen_string_literal: true

# Credit
class Credit
  SPEED = 1
  attr_reader :y

  def initialize(text, x_pos, y_pos)
    @x = x_pos
    @y = @initial_y = y_pos
    @text = text
    @font = Gosu::Font.new(10, name: 'C64_Pro_Mono-STYLE.ttf')
  end

  def move
    @y -= SPEED
  end

  def draw
    @font.draw_text(@text, @x, @y, 1)
  end

  def reset
    @y = @initial_y
  end
end
