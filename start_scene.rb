# frozen_string_literal: true

require 'gosu'
require_relative 'scene'
require_relative 'game'
require_relative 'first_wave_scene'

# StartScene
class StartScene < Scene
  def initialize
    @background_image = Gosu::Image.new('images/start_screen_ii.png')
    @start_music = Gosu::Song.new('sounds/lost_frontier.ogg')
    @start_music.play(true)
  end

  def button_down(id)
    Game.current_scene = FirstWaveScene.new
    super
  end

  def draw
    @background_image.draw(0, 0, 0)
    super
  end
end
