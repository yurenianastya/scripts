require 'json'

def generate_level(difficulty)
    num_obstacles = rand(1..4) * difficulty
    num_holes = rand(1..4) * difficulty
    num_coins = rand(1..4) * difficulty
    num_enemies = rand(1..4) * difficulty
  
    level_data = {
      "obstacles" => Array.new(num_obstacles) { |i| {"x": rand(50..800), "y": 380, "width": 40, "height": 50} },
      "holes" => Array.new(num_holes) { |i| {"x": rand(100..700), "y": 410, "width": 50, "height": 60} },
      "coins" => Array.new(num_coins) { |i| {"x": rand(130..750), "y": 380} },
      "enemies" => Array.new(num_enemies) { |i| {"x": rand(200..600), "y": 380} }
    }
  
    File.write("level#{difficulty}.json", JSON.pretty_generate(level_data))
  end
  
  generate_level(1) # Generate level 1
  generate_level(2) # Generate level 2
  generate_level(3) # Generate level 3
  