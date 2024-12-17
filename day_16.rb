data = File.read("data/day_16.txt").lines.map(&:strip)

$grid = data.map { |line| line.chars }

$unvisited = {}
$visited = {}
$distances_and_directions = {}
$distances = {}
$directions = {}
$previous_nodes = {}
$all_previous_nodes = {}
$start = []
$target = []
$final_directions = {}

$grid.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    if cell == "S"
      $start = [i,j], :right
    elsif cell == "E"
      $target = [i,j]
      $unvisited[[i,j]] = true
    elsif cell == "."
      $unvisited[[i,j]] = true
    end
  end
end

def part_1
  time = Time.now
  current_node = $start[0]
  current_direction = $start[1]
  $visited[current_node] = true
  $distances_and_directions[[current_node,current_direction]] = [0, current_direction]
  $distances[current_node] = 0
  $directions[current_node] = current_direction
  $previous_nodes[current_node] = true
  $all_previous_nodes[current_node] = []
  while $unvisited.keys.any?
    $unvisited.delete(current_node)
    $visited[current_node] = true
    percent_seen = ($visited.keys.length.to_f / ($visited.keys.length + $unvisited.keys.length)) * 100
    p "Percent seen: #{percent_seen}%" if $unvisited.keys.length % 100 == 0
    explore_neighbors(current_node, current_direction)
    min_distance = Float::INFINITY
    current_node = nil
    current_direction = nil
    $unvisited.keys.each do |node|
      # $distances_and_directions.filter { |k,v| k[0] == node }.each do |k,v|
      #   if v[0] < min_distance
      #     min_distance = v[0]
      #     current_node = k[0]
      #     current_direction = v[1]
      #   end
      # end
      if $distances[node] && $distances[node] < min_distance
        min_distance = $distances[node]
        current_node = node
        current_direction = $directions[node]
      end
    end
  end
  # min_distance = Float::INFINITY
  # $distances_and_directions.filter { |k,v| k[0] == $target }.each do |k,v|
  #   if v[0] < min_distance
  #     min_distance = v[0]
  #     current_node = k[0]
  #     current_direction = v[1]
  #   end
  # end
  p "Time: #{Time.now - time}"
  $distances[$target]
end

def explore_neighbors(current_node,current_direction)
  neighbors = get_neighbors(current_node)
  if neighbors.include?($previous_nodes[current_node])
    neighbors.delete($previous_nodes[current_node])
  end
  min_distance = 20000
  next_node = nil
  next_direction = nil
  neighbors.each do |neighbor|
    cost = if current_direction == :right && neighbor[1] > current_node[1]
      1
    elsif current_direction == :left && neighbor[1] < current_node[1]
      1
    elsif current_direction == :up && neighbor[0] < current_node[0]
      1
    elsif current_direction == :down && neighbor[0] > current_node[0]
      1
    else
      1001
    end
    direction = if current_node[1] < neighbor[1]
      :right
    elsif current_node[1] > neighbor[1]
      :left
    elsif current_node[0] < neighbor[0]
      :down
    elsif current_node[0] > neighbor[0]
      :up
    end
    potential_distance = $distances[current_node] + cost
    if $distances[neighbor] && $distances[neighbor] < potential_distance
      next
    else
      if $distances[neighbor] && $distances[neighbor] == potential_distance
        if $all_previous_nodes[neighbor]
          $all_previous_nodes[neighbor] << current_node
        else
          $all_previous_nodes[neighbor] = [current_node]
        end
      elsif $distances[neighbor] && $distances[neighbor] > potential_distance
        $all_previous_nodes[neighbor] = [current_node]
      elsif !$distances[neighbor]
        $all_previous_nodes[neighbor] = [current_node]
      end
      $distances[neighbor] = potential_distance
      $directions[neighbor] = direction
      $final_directions[$previous_nodes[current_node]] = direction
      $previous_nodes[neighbor] = current_node
    end
    if potential_distance < min_distance
      min_distance = potential_distance
      next_node = neighbor
      next_direction = direction
    end
  end
  [next_node, next_direction]
end

def get_neighbors(current_node)
  neighbors = []
  if $grid[current_node[0] - 1][current_node[1]] != "#"
    neighbors.push([current_node[0] - 1, current_node[1]])
  end
  if $grid[current_node[0] + 1][current_node[1]] != "#"
    neighbors.push([current_node[0] + 1, current_node[1]])
  end
  if $grid[current_node[0]][current_node[1] - 1] != "#"
    neighbors.push([current_node[0], current_node[1] - 1])
  end
  if $grid[current_node[0]][current_node[1] + 1] != "#"
    neighbors.push([current_node[0], current_node[1] + 1])
  end
  neighbors
end

p "Part 1: #{part_1}"

count_on_shortest_path = 0
end_node = $target
while $previous_nodes[end_node]
  count_on_shortest_path += 1
  end_node = $previous_nodes[end_node]
end
p "count on shortest path: #{count_on_shortest_path}"

def part_2
  time = Time.now
  alternate_path_ends = [$target]
  seen = Set.new
  
  while alternate_path_ends.any?
    current_node = alternate_path_ends.shift
    seen.add(current_node)
    while $previous_nodes[current_node]

      seen.add(current_node)

      to_check = get_neighbors(current_node)
      while to_check.any?
        checking = to_check.shift
        next if seen.include?(checking)
        if checking == $previous_nodes[current_node]
          next
        end
        p "checking: #{checking}"
        if $directions[current_node]
          if (($final_directions[current_node] == :up && checking[0] > current_node[0]) || ($final_directions[current_node] == :down && checking[0] < current_node[0]) || ($final_directions[current_node] == :left && checking[1] > current_node[1]) || ($final_directions[current_node] == :right && checking[1] < current_node[1]))
            if $distances[checking] - 999 == $distances[current_node]
              p "checking: #{checking}"
              p "instead of: #{$previous_nodes[current_node]}"
              alternate_path_ends << checking
            end
          end
        else
          if $distances[checking] + 1 == $distances[current_node]
            p "checking: #{checking}"
            p "instead of: #{$previous_nodes[current_node]}"
            alternate_path_ends << checking
          end
        end
      end
      current_node = $previous_nodes[current_node]
    end
  end


  count = 0
  $grid.each_with_index do |row, i|
    line = ""
    row.each_with_index do |cell, j|
      if $grid[i][j] == "#"
        line += "||||||||"
      elsif seen.include?([i,j])
        count += 1
        sym = if $final_directions[[i,j]] == :right
          ">"
        elsif $final_directions[[i,j]] == :left
          "<"
        elsif $final_directions[[i,j]] == :up
          "^"
        else 
          "v"
        end
        line += $distances[[i,j]].to_s.concat(sym).rjust(8, " ")
      else
        line += "(#{$distances[[i,j]]})".rjust(8, " ")
      end
    end
    p line
  end
  p count
  p "Time: #{Time.now - time}"
  seen.count
end


p "Part 2: #{part_2}"