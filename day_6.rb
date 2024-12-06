data = File.read("data/day_6.txt").lines.map(&:strip)

rows = data.map(&:chars)

$obstacles = {}
$position = []
$direction = nil
$number_of_rows = rows.size
$number_of_columns = rows[0].size
$new_obstacle_locations = Set.new

$seen_directions = {}
rows.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    if cell == "#"
      $obstacles[[x, y]] = true
    end
    if cell == "^"
      $position = [x, y]
      $direction = :up
    end
    if cell == "v"
      $position = [x, y]
      $direction = :down
    end
    if cell == ">"
      $position = [x, y]
      $direction = :right
    end
    if cell == "<"
      $position = [x, y]
      $direction = :left
    end
  end
end

$start_position = $position.dup
$start_direction = $direction.dup

def part_1
  seen = Set.new
  count = 0
  loop do
    count += 1
    if $position[0] < 0 || $position[0] >= $number_of_rows || $position[1] < 0 || $position[1] >= $number_of_columns
      break
    end

    seen.add($position.dup)
    $seen_directions[$position.dup] = $direction.dup

    if $direction == :up
      tenative_position = [$position[0] - 1, $position[1]]
      if $obstacles[tenative_position]
        $position = [$position[0], $position[1] + 1]
        $direction = :right
      else
        $position = tenative_position
      end
    elsif $direction == :down
      tenative_position = [$position[0] + 1, $position[1]]
      if $obstacles[tenative_position]
        $position = [$position[0], $position[1] - 1]
        $direction = :left
      else
        $position = tenative_position
      end
    elsif $direction == :right
      tenative_position = [$position[0], $position[1] + 1]
      if $obstacles[tenative_position]
        $position = [$position[0] + 1, $position[1]]
        $direction = :down
      else
        $position = tenative_position
      end
    elsif $direction == :left
      tenative_position = [$position[0], $position[1] - 1]
      if $obstacles[tenative_position]
        $position = [$position[0] - 1, $position[1]]
        $direction = :up
      else
        $position = tenative_position
      end
    end
  end
   
  seen.size
end


def cycle_check
  seen_directions_local = {}
  count = 0
  position = $start_position.dup
  direction = $start_direction.dup
  loop do
    if position[0] < 0 || position[0] >= $number_of_rows || position[1] < 0 || position[1] >= $number_of_columns
      break
    end

    if seen_directions_local[position]&.include?(direction)
      return true
    end

    if seen_directions_local[position.dup]
      seen_directions_local[position.dup].add(direction)
    else
      seen_directions_local[position.dup] = Set.new
      seen_directions_local[position.dup].add(direction)
    end


    if direction == :up
      tenative_position = [position[0] - 1, position[1]]
      if $obstacles[tenative_position]
        direction = :right
        seen_directions_local[position.dup].add(direction)
        
        tenative_position = [position[0], position[1] + 1]
        if $obstacles[tenative_position]
          direction = :down
          seen_directions_local[position.dup].add(direction)
          position = [position[0] + 1, position[1]]
        else
          position = tenative_position
        end
      else
        position = tenative_position
      end
    elsif direction == :down
      tenative_position = [position[0] + 1, position[1]]
      if $obstacles[tenative_position]
        direction = :left
        seen_directions_local[position.dup].add(direction)

        tenative_position = [position[0], position[1] - 1]
        if $obstacles[tenative_position]
          direction = :up
          seen_directions_local[position.dup].add(direction)
          position = [position[0] - 1, position[1]]
        else
          position = tenative_position
        end
      else
        position = tenative_position
      end
    elsif direction == :right
      tenative_position = [position[0], position[1] + 1]
      if $obstacles[tenative_position]
        direction = :down
        seen_directions_local[position.dup].add(direction)

        tenative_position = [position[0] + 1, position[1]]
        if $obstacles[tenative_position]
          direction = :left
          seen_directions_local[position.dup].add(direction)
          position = [position[0], position[1] - 1]
        else
          position = tenative_position
        end
      else
        position = tenative_position
      end
    elsif direction == :left
      tenative_position = [position[0], position[1] - 1]
      if $obstacles[tenative_position]
        direction = :up
        seen_directions_local[position.dup].add(direction)

        tenative_position = [position[0] - 1, position[1]]
        if $obstacles[tenative_position]
          direction = :right
          seen_directions_local[position.dup].add(direction)
          position = [position[0], position[1] + 1]
        else
          position = tenative_position
        end
      else
        position = tenative_position
      end
    end
  end
  false
end

p "Part 1: #{part_1}"


new_obstacle_count = 0
$seen_directions.keys.each do |key|
  $obstacles[key] = true unless key == $start_position
  result = cycle_check
  $obstacles[key] = false
  $obstacles.delete(key)
  if result
    new_obstacle_count += 1
  end
end


p "Part 2: #{new_obstacle_count}"

