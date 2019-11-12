# frozen_string_literal: true

require 'gosu'
require_relative 'scene'
require_relative 'credit'

# EndScene
class EndScene < Scene
  def initialize(enemies_destroyed)
    @enemies_destroyed = enemies_destroyed
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
    @message_font.draw_text(@message, 40, 40, 1, 1, 1, Gosu::Color::FUCHSIA)
    @message_font.draw_text(@message2, 40, 75, 1, 1, 1, Gosu::Color::FUCHSIA)
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
  def initialize(enemies_destroyed)
    super(enemies_destroyed)
    @message = "You made it! You destroyed #{enemies_destroyed} ships"
    @message2 = "and #{Game::MAX_ENEMIES - enemies_destroyed} reached the base."
  end
end

# EndHitByEnemyScene
class EndHitByEnemyScene < EndScene
  def initialize(enemies_destroyed)
    super(enemies_destroyed)
    @message = 'You were struck by an enemy ship.'
    @message2 = 'Before your ship was destroyed, '
    @message2 += "you took out #{enemies_destroyed} enemy ships."
  end
end

# EndOffTopScene
class EndOffTopScene < EndScene
  def initialize(enemies_destroyed)
    super(enemies_destroyed)
    @message = 'You got too close to the enemy mother ship.'
    @message2 = 'Before your ship was destroyed, '
    @message2 += "you took out #{enemies_destroyed} enemy ships."
  end
end
