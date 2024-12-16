data = File.read("data/day_16.txt").lines.map(&:strip)

$grid = data.map { |line| line.chars }

$unvisited = {}
$visited = {}
$distances_and_directions = {}
$distances = {}
$directions = {}
$previous_nodes = {}
$start = []
$target = []

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
  current_node = $start[0]
  current_direction = $start[1]
  $visited[current_node] = true
  $distances_and_directions[[current_node,current_direction]] = [0, current_direction]
  $distances[current_node] = 0
  $directions[current_node] = current_direction
  $previous_nodes[current_node] = nil
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
  $distances[$target]
end

def explore_neighbors(current_node,current_direction)
  neighbors = get_neighbors(current_node)
  if neighbors.include?($previous_nodes[current_node])
    neighbors.delete($previous_nodes[current_node])
  end
  min_distance = 10000
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
      $distances[neighbor] = potential_distance
      $directions[neighbor] = direction
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