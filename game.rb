require_relative 'start_scene'

class Game
  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600
  ENEMY_FREQUENCY = 0.05
  MAX_ENEMIES = 100
  
  class << self
     attr_accessor :current_scene, :window
  end

  def initialize(window)
    Game.current_scene = StartScene.new
    Game.window = window    
  end  
end
