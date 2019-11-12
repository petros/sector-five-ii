# frozen_string_literal: true

require 'gosu'

# HorizontalText
class HorizontalText
  def initialize(x_pos, y_pos)
    @text = []
    @x = x_pos
    @y = y_pos
    @font = Gosu::Font.new(12, name: 'C64_Pro_Mono-STYLE.ttf')
  end

  def clear
    @text = []
  end

  def add(text, color)
    @text << { text: text, color: color }
  end

  def draw
    x = @x
    @text.each do |t|
      @font.draw_text(t[:text], x, @y, 1, 1, 1, t[:color])
      x += @font.text_width(t[:text]) + 20
    end
  end
end
