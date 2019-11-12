require 'gosu'

class HorizontalText

  def initialize(x, y)
    @text = []
    @x = x
    @y = y
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

