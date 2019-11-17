# frozen_string_literal: true

require 'gosu'
require_relative 'scene'
require_relative 'credit'

# EndScene
class EndScene < Scene
  def initialize(remaining)
    @enemies_destroyed = remaining
    @bottom_message = 'Press P to play again, or Q to quit.'
    @message_font = Gosu::Font.new(12, name: 'C64_Pro_Mono-STYLE.ttf')
    @bottom_message_width = @message_font.text_width(@bottom_message)
    @bottom_message_x = (Game::WINDOW_WIDTH - @bottom_message_width) / 2
    @credits = []
    load_credits
    @end_music = Gosu::Song.new('sounds/from_here.ogg')
    @end_music.play(true)
  end

  def button_down(id)
    Game.current_scene = FirstWaveScene.new if id == Gosu::KbP
    Game.window.close if id == Gosu::KbQ
  end

  def update
    @credits.each(&:move)
    @credits.each(&:reset) if @credits.last.y < 150
  end

  def draw
    Gosu.clip_to(50, 140, 700, 360) { @credits.each(&:draw) }
    Gosu.draw_line(0, 140, Gosu::Color::RED, Game::WINDOW_WIDTH, 140,
                   Gosu::Color::RED)
    @message_font.draw_text(@message, 40, 20, 1, 1, 1, Gosu::Color::FUCHSIA)
    @message_font.draw_text(@message2, 40, 55, 1, 1, 1, Gosu::Color::FUCHSIA)
    @message_font.draw_text(@message3, 40, 90, 1, 1, 1, Gosu::Color::FUCHSIA)
    Gosu.draw_line(0, 500, Gosu::Color::RED, Game::WINDOW_WIDTH, 500,
                   Gosu::Color::RED)
    @message_font.draw_text(@bottom_message, @bottom_message_x, 540, 1, 1, 1,
                            Gosu::Color::AQUA)
  end

  private

  def load_credits
    y = 700
    File.open('credits.txt').each do |line|
      @credits.push(Credit.new(line.chomp, 100, y))
      y += 30
    end
  end
end

# EndCountReachedScene
class EndCountReachedScene < EndScene
  def initialize(remaining)
    super(remaining)
    @message = 'You made it! You destroyed all enemy ships!'
  end
end

# EndHitByEnemyScene
class EndHitByEnemyScene < EndScene
  def initialize(remaining)
    super(remaining)
    @message = 'You were struck by an enemy ship.'
    @message2 = 'Before your ship was destroyed, '
    @message3 = "there were #{remaining} remaining enemy ships."
  end
end

# EndOffTopScene
class EndOffTopScene < EndScene
  def initialize(remaining)
    super(remaining)
    @message = 'You got too close to the enemy mother ship.'
    @message2 = 'Before your ship was destroyed, '
    @message3 = "there were #{remaining} remaining enemy ships."
  end
end
