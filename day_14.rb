data = File.read("data/day_14.txt").lines.map(&:strip)

$positions = []
$velocities = []

HEIGHT = 103
WIDTH = 101

data.each do |line|
  pos = line.split(" ")[0]
  vel = line.split(" ")[1]
  pos = pos.split("=")[1]
  vel = vel.split("=")[1]

  $positions << pos.split(",").map(&:to_i)
  $velocities << vel.split(",").map(&:to_i)
end

$original_positions = $positions.map(&:dup)

def part_1
  $positions.each_with_index do |pos, i|
    x_vel = $velocities[i][0]
    y_vel = $velocities[i][1]
    x_pos_change = (x_vel * 100) % WIDTH
    y_pos_change = (y_vel * 100) % HEIGHT

    $positions[i][0] += x_pos_change
    if $positions[i][0] >= WIDTH
      $positions[i][0] -= WIDTH
    end
    if $positions[i][0] < 0
      $positions[i][0] += WIDTH
    end
    $positions[i][1] += y_pos_change
    if $positions[i][1] >= HEIGHT
      $positions[i][1] -= HEIGHT
    end
    if $positions[i][1] < 0
      $positions[i][1] += HEIGHT
    end
  end
  top_left = $positions.filter { |pos| pos[0] <= WIDTH/2-1 && pos[1] <= HEIGHT/2-1 }.count
  top_right = $positions.filter { |pos| pos[0] >= WIDTH/2 +1 && pos[1] <= HEIGHT/2-1 }.count
  bottom_left = $positions.filter { |pos| pos[0] <= WIDTH/2-1 && pos[1] >= HEIGHT/2 + 1 }.count
  bottom_right = $positions.filter { |pos| pos[0] >= WIDTH/2 + 1 && pos[1] >= HEIGHT/2 + 1 }.count

  top_left * top_right * bottom_left * bottom_right
end

def part_2
  $positions = $original_positions
  found_time = nil
  possible_trees = []
  positions = $positions.map(&:dup)
  (1..10500).each do |s|
    p s if s % 100 == 0
    $positions.each_with_index do |pos, i|
      x_vel = $velocities[i][0]
      y_vel = $velocities[i][1]
      x_pos_change = (x_vel * s) % WIDTH
      y_pos_change = (y_vel * s) % HEIGHT
  
      positions[i][0] = $positions[i][0] + x_pos_change
      if positions[i][0] >= WIDTH
        positions[i][0] -= WIDTH
      end
      if positions[i][0] < 0
        positions[i][0] += WIDTH
      end
      positions[i][1] = $positions[i][1] + y_pos_change
      if positions[i][1] >= HEIGHT
        positions[i][1] -= HEIGHT
      end
      if positions[i][1] < 0
        positions[i][1] += HEIGHT
      end
    end
    
    found = false

    
    (0...$positions.length).each_with_index do |i, index|
      x = positions[i][0]
      y = positions[i][1]

      if positions.include?([x, y+1]) && positions.include?([x, y-1]) && positions.include?([x+1, y]) && positions.include?([x-1, y]) && positions.include?([x+1, y+1]) && positions.include?([x-1, y-1]) && positions.include?([x+1, y-1]) && positions.include?([x-1, y+1])
        p "Found at #{s}"
        possible_trees << [s, positions.map(&:dup)]
        break
      end
    end

    if positions.all? { |pos| $positions.include?(pos) }
      p "repeat positions at #{s}"
    end
  end
    
  
  possible_trees.each do |entry|
    seconds = entry[0]
    robots = entry[1]
    p "Seconds: #{seconds}"
  
    (0...HEIGHT).each do |y|
      line = ""
      (0...WIDTH).each do |x|
        if robots.include?([x, y])
          line += "#"
        else
          line += "."
        end
      end
      p line
    end
    p "---------------------------"
    sleep(10)
  end
  nil
end

p "Part 1: #{part_1}"
p "Part 2: #{part_2}"
