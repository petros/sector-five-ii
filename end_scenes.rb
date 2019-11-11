require 'gosu'
require_relative 'scene'
require_relative 'credit'

class EndScene < Scene
  def initialize(enemies_destroyed)
    @enemies_destroyed = enemies_destroyed
    @bottom_message = "Press P to play again, or Q to quit."
    @message_font = Gosu::Font.new(28)
    @credits = []
    y = 700
    File.open('credits.txt').each do |line|
      @credits.push(Credit.new(self, line.chomp, 100, y))
      y += 30
    end
    @scene = :end
    @end_music = Gosu::Song.new('sounds/from_here.ogg')
    @end_music.play(true)
  end

  def button_down(id)
    if id == Gosu::KbP
      Game.current_scene = FirstWaveScene.new
    elsif id == Gosu::KbQ
      Game.window.close
    end
  end

  def update
    @credits.each do |credit|
      credit.move
    end
    if @credits.last.y < 150
      @credits.each do |credit|
        credit.reset
      end
    end
  end

  def draw
    Gosu.clip_to(50, 140, 700, 360) do
      @credits.each do |credit|
        credit.draw
      end
    end
    Gosu.draw_line(0, 140, Gosu::Color::RED, Game::WINDOW_WIDTH, 140, Gosu::Color::RED)
    @message_font.draw_text(@message, 40, 40, 1, 1, 1, Gosu::Color::FUCHSIA)
    @message_font.draw_text(@message2, 40, 75, 1, 1, 1, Gosu::Color::FUCHSIA)
    Gosu.draw_line(0, 500, Gosu::Color::RED, Game::WINDOW_WIDTH, 500, Gosu::Color::RED)
    @message_font.draw_text(@bottom_message, 180, 540, 1, 1, 1, Gosu::Color::AQUA)
  end  
end

class EndCountReachedScene < EndScene
  def initialize(enemies_destroyed)
    super(enemies_destroyed)
    @message = "You made it! You destroyed #{enemies_destroyed} ships"
    @message2 = "and #{Game::MAX_ENEMIES - enemies_destroyed} reached the base."
  end
end

class EndHitByEnemyScene < EndScene
  def initialize(enemies_destroyed)
    super(enemies_destroyed)
    @message = "You were struck by an enemy ship."
    @message2 = "Before your ship was destroyed, "
    @message2 += "you took out #{enemies_destroyed} enemy ships."
  end
end

class EndOffTopScene < EndScene
  def initialize(enemies_destroyed)
    super(enemies_destroyed)
    @message = "You got too close to the enemy mother ship."
    @message2 = "Before your ship was destroyed, "
    @message2 += "you took out #{enemies_destroyed} enemy ships."
  end
end
