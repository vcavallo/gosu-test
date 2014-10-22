require 'gosu'

class TestWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Hello World!"

    @background_image = Gosu::Image.new(self, "media/space.jpg", true)

    @player = Player.new(self)
    @player.warp(320, 240)
  end

  def update
    if button_down?(Gosu::KbLeft) || button_down?(Gosu::GpLeft)
      @player.turn_left
    end
    if button_down?(Gosu::KbRight) || button_down?(Gosu::GpRight)
      @player.turn_right
    end
    if button_down?(Gosu::KbUp) || button_down?(Gosu::GpButton0)
      @player.accelerate
    end
    @player.move
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

end

##############

class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "media/star-fighter.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

window = TestWindow.new
window.show
