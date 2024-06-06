require 'ruby2d'
require 'json'

set background: 'blue'
set width: 800

class Player
  attr_accessor :x, :y, :sprite, :health, :score, :jumping, :velocity, :moving_left, :moving_right

  def initialize
    @x = 0
    @y = 380
    @velocity = 0
    @jumping = false
    @moving_left = false
    @moving_right = false
    @sprite = Sprite.new(
      'player.png',
      x: @x, y: @y,
      width: 32, height: 32,
      time: 300
    )
    @health = 3
    @score = 0
  rescue => e
    puts "Failed to load player sprite: #{e.message}"
    exit
  end

  def move_left
    @moving_left = true
    @moving_right = false
  end

  def move_right
    @moving_right = true
    @moving_left = false
  end

  def stop_moving
    @moving_left = false
    @moving_right = false
  end

  def jump
    return if @jumping
    @jumping = true
    @velocity = -10
  end

  def update
    @x -= 5 if @moving_left
    @x += 5 if @moving_right

    @y += @velocity
    @velocity += 0.5 if @jumping
    if @y >= 380
      @y = 380
      @velocity = 0
      @jumping = false
    end
    @sprite.x = @x
    @sprite.y = @y
  end

  def collect_coin
    @score += 1
  end

  def alive?
    @health > 0
  end
end

class Game
  attr_reader :player

  def initialize
    @player = Player.new
    @obstacles = []
    @holes = []
    @coins = []
    @enemies = []
    @level = 1

    load_level(@level)
  end

  def load_level(level)
    data = JSON.parse(File.read("level#{level}.json"))
    data['obstacles'].each do |obs|
      @obstacles << Rectangle.new(x: obs['x'], y: obs['y'], width: obs['width'], height: obs['height'], color: 'gray')
    end
    data['holes'].each do |hole|
      @holes << Rectangle.new(x: hole['x'], y: hole['y'], width: hole['width'], height: hole['height'], color: 'black')
    end
    data['coins'].each do |coin|
      @coins << Sprite.new('coin.png', x: coin['x'], y: coin['y'], width: 32, height: 32)
    end
    data['enemies'].each do |enemy|
      @enemies << Enemy.new(enemy['x'], enemy['y'])
    end
  end

  def run_game
    @player.update

    if @player.sprite.x == 800
      Window.close
    end

    @obstacles.each do |obstacle|
      if @player.sprite.y + @player.sprite.height >= obstacle.y && @player.sprite.x + @player.sprite.width >= obstacle.x && @player.sprite.x <= obstacle.x + obstacle.width
        reset_game
      end
    end

    @holes.each do |hole|
      if @player.sprite.y + @player.sprite.height >= hole.y && @player.sprite.x + @player.sprite.width >= hole.x && @player.sprite.x <= hole.x + hole.width
        reset_game
      end
    end

    @coins.each do |coin|
      if @player.sprite.y + @player.sprite.height >= coin.y && @player.sprite.x + @player.sprite.width >= coin.x && @player.sprite.x <= coin.x + coin.width
        @player.collect_coin
        coin.remove
        @coins.delete(coin)
      end
    end

    @enemies.each do |enemy|
      enemy.update
      if @player.sprite.y + @player.sprite.height >= enemy.y && @player.sprite.x + @player.sprite.width >= enemy.x && @player.sprite.x <= enemy.x + enemy.sprite.width
        if @player.velocity >= 0
          enemy.die
        end
      end
    end

    update_hud
  end

def reset_game
  @player.x = 0
  @player.health -= 1
end


  def update_hud
    @score_text.remove if @score_text
    @health_text.remove if @health_text
    @score_text = Text.new("Score: #{@player.score}", x: 10, y: 10, size: 20, color: 'white')
    @health_text = Text.new("Health: #{@player.health}", x: 550, y: 10, size: 20, color: 'white')
  end
end

class Enemy
  attr_accessor :x, :y, :sprite, :direction, :distance, :initial_x, :dead

  def initialize(x, y)
    @x = x
    @y = y
    @initial_x = x
    @direction = rand < 0.5 ? -1 : 1
    @distance = 0
    @dead = false
    begin
      @sprite = Sprite.new(
        'enemy.png',
        x: @x, y: @y,
        width: 32, height: 32,
        time: 300
      )
    rescue => e
      puts "Failed to load enemy sprite: #{e.message}"
      exit
    end
  end

  def update
    return if @dead
    @x += @direction
    @distance += 1
    @sprite.x = @x

    if @distance >= 60 || @x < 0 || @x > (Window.width - @sprite.width)
      @direction *= -1
      @distance = 0
    end
  end

  def die
    @dead = true
    @sprite.remove
  end
end

game = Game.new

on :key_held do |event|
  case event.key
  when 'a'
    game.player.move_left
  when 'd'
    game.player.move_right
  when 'space'
    game.player.jump
  end
end

on :key_up do |event|
  case event.key
  when 'a', 'd'
    game.player.stop_moving
  end
end

update do
  game.run_game
  
  if !game.player.alive?
    Window.close
  end
end

show
