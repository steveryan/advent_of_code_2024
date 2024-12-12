data = File.read("data/day_12.txt").lines.map(&:strip)

$grid = data.map { |line| line.chars }


$seen = {}
$neighbors = {}
def part_1
  char_neighbor_counts = {}
  $regions = []
  $grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      next if $seen["#{i},#{j}"]

      search_queue = [[i,j]]
      region = [[i,j]]
      while search_queue.any?
        next_up = search_queue.shift
        next if $seen["#{next_up[0]},#{next_up[1]}"]
        $seen["#{next_up[0]},#{next_up[1]}"] = true

        neighbors = find_neighbors(next_up[0], next_up[1])
        search_queue += neighbors
        region += neighbors
      end
      $regions << region
    end
  end
  

  total_price = 0
  $regions.each do |region|
    area = region.uniq.length
    perim = 0
    region.uniq.each do |cell|
      perim += 4 - $neighbors["#{cell[0]},#{cell[1]}"]
    end
    price = area * perim
    total_price += price
  end
  total_price
end


def part_2
  total_price = 0
  $regions.each do |region|
    area = region.uniq.length
    corners = 0
    region.uniq.each do |cell|
      corners += corners(cell)
    end
    price = area * corners
    total_price += price
  end
  total_price
end

def find_neighbors(i,j)
  i = i.to_i
  j = j.to_i
  char = $grid[i][j]
  neighbors = []
  if i > 0
    neighbors << [i-1,j] if $grid[i-1][j] == char
  end
  if i < $grid.length - 1
    neighbors << [i+1,j] if $grid[i+1][j] == char
  end
  if j > 0
    neighbors << [i,j-1] if $grid[i][j-1] == char
  end
  if j < $grid[i].length - 1
    neighbors << [i,j+1] if $grid[i][j+1] == char
  end
  $neighbors["#{i},#{j}"] = neighbors.count
  neighbors
end

def corners(cell)
  i = cell[0]
  j = cell[1]
  char = $grid[i][j]
  up = i > 0 ? $grid[i-1][j] : nil
  down = i < $grid.length - 1 ? $grid[i+1][j] : nil
  left = j > 0 ? $grid[i][j-1] : nil
  right = j < $grid[i].length - 1 ? $grid[i][j+1] : nil

  corners = 0
  if up != char
    if left != char
      corners += 1
    end
    if right != char
      corners += 1
    end
  end
  if down != char
    if left != char
      corners += 1
    end
    if right != char
      corners += 1
    end
  end
  
  # Now check for inside corners
  if up == char
    if left == char
      corners += 1 unless $grid[i-1][j-1] == char
    end
    if right == char
      corners += 1 unless $grid[i-1][j+1] == char
    end
  end
  if down == char
    if left == char
      corners += 1 unless $grid[i+1][j-1] == char
    end
    if right == char
      corners += 1 unless $grid[i+1][j+1] == char
    end
  end
  corners
end

p "Part 1: #{part_1}"
p "Part 2: #{part_2}"