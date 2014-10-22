require 'gosu'

class TestWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Hello World!"

    @background_image = Gosu::Image.new(self, "media/space.jpg", true)

    @player = Player.new(self)
    @player.warp(320, 240)

    @star_animation = Gosu::Image::load_tiles(self, "media/star.png", 25, 25, false)
    @stars = Array.new

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
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
    @player.collect_stars(@stars)

    if rand(100) < 4 && @stars.size < 25
      @stars.push(Star.new(@star_animation))
    end
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
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

  def score
    @score
  end

  def collect_stars(stars)
    if stars.reject! { |star| Gosu::distance(@x, @y, star.x, star.y) < 35 }
      @score += 10
      true
    else
      false
    end
  end

end

#################

module ZOrder
  Background = 0
  Stars = 1
  Player = 2
  UI = 3
end

class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y= rand * 480
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0, ZOrder::Stars, 1, 1, @color, :add)
  end
end

window = TestWindow.new
window.show
