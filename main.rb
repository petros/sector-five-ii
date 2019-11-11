require 'gosu'
require_relative 'game'

class SectorFive < Gosu::Window    
  def initialize
    super(Game::WINDOW_WIDTH, Game::WINDOW_HEIGHT)
    self.caption = 'Sector Five II'
    Game.new(self)
  end
  
  def button_down(id)
    Game.current_scene.button_down(id)
  end
  
  def update
    Game.current_scene.update
  end
  
  def draw
    Game.current_scene.draw
  end  
end

window = SectorFive.new
window.show
