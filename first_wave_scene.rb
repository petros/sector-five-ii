# frozen_string_literal: true

require 'gosu'
require_relative 'game'
require_relative 'scene'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'end_scenes'
require_relative 'horizontal_text'
require_relative 'transition_scene'

# FirstWaveScene
# rubocop:disable ClassLength
class FirstWaveScene < Scene
  def initialize(enemy_count = 100)
    @enemy_count = enemy_count
    @scene = :first_wave
    @player = Player.new(Game.window)
    init_counters
    init_arrays
    @ht = HorizontalText.new(320, 10)
    initialize_sounds
  end

  def button_down(id)
    return unless id == Gosu::KbSpace

    @bullets.push Bullet.new(Game.window, @player.x, @player.y, @player.angle)
    @shooting_sound.play(0.3)
  end

  # rubocop:disable MethodLength
  def update
    move_player
    add_enemy
    @enemies.each(&:move)
    @bullets.each(&:move)
    detect_bullet_enemy_collisions
    chain_enemy_explosions
    remove_finished_explosions
    remove_escaped_enemies
    remove_offscreen_bullets
    detect_enemy_wave_finished
    detect_player_hit_by_enemy
    detect_player_off_top
  end

  def draw
    @player.draw
    @enemies.each(&:draw)
    @bullets.each(&:draw)
    @explosions.each(&:draw)
    @ht.clear
    fleet = @enemy_count - @enemies_appeared
    @ht.add("Fleet: #{fleet}", Gosu::Color::WHITE)
    @ht.add("Destroyed: #{@enemies_destroyed}", Gosu::Color::GREEN)
    @ht.add("Escaped: #{@enemies_escaped}", Gosu::Color::RED)
    @ht.draw
  end
  # rubocop:enable MethodLength

  private

  def init_arrays
    @enemies = []
    @bullets = []
    @explosions = []
  end

  def init_counters
    @enemies_appeared = 0
    @enemies_escaped = 0
    @enemies_destroyed = 0
  end

  def move_player
    @player.turn_left if Gosu.button_down?(Gosu::KbLeft)
    @player.turn_right if Gosu.button_down?(Gosu::KbRight)
    @player.accelerate if Gosu.button_down?(Gosu::KbUp)
    @player.move
  end

  def initialize_sounds
    @game_music = Gosu::Song.new('sounds/cephalopod.ogg')
    @game_music.play(true)
    @explosion_sound = Gosu::Sample.new('sounds/explosion.ogg')
    @shooting_sound = Gosu::Sample.new('sounds/shoot.ogg')
    @teleport_sound = Gosu::Sample.new('sounds/teleport.wav')
  end

  def add_enemy
    return unless @enemies_appeared < @enemy_count
    return unless rand < Game::ENEMY_FREQUENCY

    @enemies.push Enemy.new(Game.window)
    @enemies_appeared += 1
  end

  def detect_bullet_enemy_collisions
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        next unless bullet.collides_with?(enemy)

        @enemies.delete enemy
        @enemies_destroyed += 1
        @bullets.delete bullet
        @explosions.push Explosion.new(enemy.x, enemy.y)
        @explosion_sound.play
      end
    end
  end

  def chain_enemy_explosions
    @enemies.dup.each do |enemy|
      @explosions.dup.each do |explosion|
        next unless enemy.collides_with?(explosion)

        @enemies.delete enemy
        @enemies_destroyed += 1
        @explosions.push Explosion.new(enemy.x, enemy.y)
        @explosion_sound.play
      end
    end
  end

  def remove_finished_explosions
    @explosions.dup.each do |explosion|
      @explosions.delete explosion if explosion.finished
    end
  end

  def remove_escaped_enemies
    @enemies.dup.each do |enemy|
      next unless enemy.y > Game::WINDOW_HEIGHT + enemy.radius

      @enemies.delete enemy
      @enemies_escaped += 1
      @teleport_sound.play(0.3)
    end
  end

  def remove_offscreen_bullets
    @bullets.dup.each do |bullet|
      @bullets.delete bullet unless bullet.onscreen?
    end
  end

  def detect_player_hit_by_enemy
    @enemies.each do |enemy|
      if enemy.collides_with?(@player)
        remaining = @enemy_count - @enemies_destroyed
        Game.current_scene = EndHitByEnemyScene.new(remaining)
      end
    end
  end

  def detect_player_off_top
    return unless @player.off_top?

    remaining = @enemy_count - @enemies_destroyed
    Game.current_scene = EndOffTopScene.new(remaining)
  end

  def inform_player
    text = []
    text << 'You made it this round!'
    text << "You have destroyed #{@enemies_destroyed} enemies so far."
    remaining = @enemies_escaped
    text << "Prepare to destroy the remaining #{remaining} enemy ships."
    next_scene =
      proc { Game.current_scene = FirstWaveScene.new(remaining) }
    Game.current_scene = TransitionScene.new(text, next_scene, font_size: 14)
  end

  def detect_enemy_wave_finished
    total = @enemies_escaped + @enemies_destroyed
    return unless total == @enemy_count

    remaining = @enemies_escaped
    if remaining.zero?
      Game.current_scene = EndCountReachedScene.new
    else
      inform_player
    end
  end
end
# rubocop:enable ClassLength
