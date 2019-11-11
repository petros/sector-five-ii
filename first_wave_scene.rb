require 'gosu'
require_relative 'game'
require_relative 'scene'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'end_scenes'

class FirstWaveScene < Scene
  def initialize
    @scene = :first_wave
    @player = Player.new(Game.window)
    @enemies = []
    @bullets = []
    @explosions = []
    @enemies_appeared = 0
    @enemies_appeared_font = Gosu::Font.new(18, bold: true)
    @enemies_destroyed = 0
    @enemies_destroyed_font = Gosu::Font.new(18, bold: true)
    @enemies_escaped_font = Gosu::Font.new(18, bold: true)
    @game_music = Gosu::Song.new('sounds/cephalopod.ogg')
    @game_music.play(true)
    @explosion_sound = Gosu::Sample.new('sounds/explosion.ogg')
    @shooting_sound = Gosu::Sample.new('sounds/shoot.ogg')
    @teleport_sound = Gosu::Sample.new('sounds/teleport.wav')
  end
  
  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(Game.window, @player.x, @player.y, @player.angle)
      @shooting_sound.play(0.3)
    end
  end
  
  def update
    @player.turn_left if Gosu.button_down?(Gosu::KbLeft)
    @player.turn_right if Gosu.button_down?(Gosu::KbRight)
    @player.accelerate if Gosu.button_down?(Gosu::KbUp)
    @player.move
    if rand < Game::ENEMY_FREQUENCY
      @enemies.push Enemy.new(Game.window)
      @enemies_appeared += 1
    end
    @enemies.each do |enemy|
      enemy.move
    end
    @bullets.each do |bullet|
      bullet.move
    end
    # Detect if a bullet hits an enemy, and push an explosion.
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        if bullet.collides_with?(enemy)
          @enemies.delete enemy
          @enemies_destroyed += 1
          @bullets.delete bullet
          @explosions.push Explosion.new(Game.window, enemy.x, enemy.y)
          @explosion_sound.play
        end
      end
    end
    # Chain explosions. If an enemy is near an ongoing explosion, it explodes
    # too.
    @enemies.dup.each do |enemy|
      @explosions.dup.each do |explosion|
        if enemy.collides_with?(explosion)
          @enemies.delete enemy
          @enemies_destroyed += 1
          @explosions.push Explosion.new(Game.window, enemy.x, enemy.y)
          @explosion_sound.play
        end
      end
    end
    # Remove explosions that have finished animating.
    @explosions.dup.each do |explosion|
      @explosions.delete explosion if explosion.finished
    end
    # Remove enemies that have moved beyond the bottom of the screen.
    @enemies.dup.each do |enemy|
      if enemy.y > Game::WINDOW_HEIGHT + enemy.radius
        @enemies.delete enemy
        @teleport_sound.play(0.3)
      end
    end
    # Remove bullets that have moved out of the screen boundaries.
    @bullets.dup.each do |bullet|
      @bullets.delete bullet unless bullet.onscreen?
    end
    if @enemies_appeared > Game::MAX_ENEMIES
      Game.current_scene = EndCountReachedScene.new(@enemies_destroyed)
    end
    @enemies.each do |enemy|
      #distance = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
      #if distance < @player.radius + enemy.radius
      if enemy.collides_with?(@player)
        Game.current_scene = EndHitByEnemyScene.new(@enemies_destroyed)
      end
    end
    if @player.y < @player.radius
      Game.current_scene = EndOffTopScene.new(@enemies_destroyed)
    end
  end
  
  def draw
    @player.draw
    @enemies.each do |enemy|
      enemy.draw
    end
    @bullets.each do |bullet|
      bullet.draw
    end
    @explosions.each do |explosion|
      explosion.draw
    end
    @enemies_appeared_font.draw_text(
      "Fleet: #{Game::MAX_ENEMIES - @enemies_appeared}",
      460,
      10,
      1,
      1,
      1,
      Gosu::Color::WHITE
    )
    @enemies_destroyed_font.draw_text(
      "Destroyed: #{@enemies_destroyed}",
      540,
      10,
      1,
      1,
      1,
      Gosu::Color::GREEN
    )
    @enemies_escaped_font.draw_text(
      "Escaped: #{Game::MAX_ENEMIES - @enemies_destroyed}",
      660,
      10,
      1,
      1,
      1,
      Gosu::Color::RED
    )
  end
  
end