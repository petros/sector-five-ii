# frozen_string_literal: true

require 'gosu'

# TransitionScene
class TransitionScene
  ROW_PADDING = 20

  def initialize(text, next_scene, wait_seconds: 6,
                 font_size: 12, font_color: Gosu::Color::WHITE)
    @next_scene = next_scene
    @text = text
    @wait_seconds = wait_seconds
    @font_color = font_color
    @font = Gosu::Font.new(font_size, name: 'C64_Pro_Mono-STYLE.ttf')
  end

  def button_down(id); end

  def update
    @wait_seconds -= 1
    sleep(1)
    @next_scene.call if @wait_seconds.negative?
    @seconds_to_next_level = @wait_seconds + 1
  end

  def dt(text, x_pos, offset)
    @font.draw_text(text, x_pos, offset, 1, 1, 1, @font_color)
  end

  def calculate_y
    total_rows = @text.count + 1 # including the number of seconds
    padded_row_height = @font.height + ROW_PADDING
    text_area_height = total_rows * padded_row_height
    (Game::WINDOW_HEIGHT - text_area_height) / 2
  end

  def calculate_x(text)
    width = @font.text_width(text)
    (Game::WINDOW_WIDTH - width) / 2
  end

  def draw
    offset = calculate_y
    @text.each do |t|
      dt(t, calculate_x(t), offset)
      offset += @font.height + ROW_PADDING
    end
    offset += ROW_PADDING
    x = calculate_x(@seconds_to_next_level)
    dt(@seconds_to_next_level, x, offset)
  end
end
