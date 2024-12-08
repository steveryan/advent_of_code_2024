data = File.read("data/day_8.txt").lines.map(&:strip)
$rows = data.map { |row| row.chars }

$antennas = {}
$antenna_coords = {}
$antinodes = Set.new
$rows.each_with_index do |row,i|
  row.each_with_index do |char,j|
    if char != "."
      $antenna_coords[[i,j]] = true
      if $antennas[char].nil?
        $antennas[char] = [[i,j]]
      else
        $antennas[char] << [i,j]
      end
    end
  end
end

def part_1
  $antennas.each do |k,v|
    v.to_a.combination(2).each do |a,b|
      row_diff = (a[0] - b[0])
      col_diff = (a[1] - b[1])
      new_antinode_1 = [a[0] + row_diff, a[1] + col_diff]
      new_antinode_2 = [b[0] - row_diff, b[1] - col_diff]

      if new_antinode_1[0] >= 0 && new_antinode_1[0] < $rows.size && new_antinode_1[1] >= 0 && new_antinode_1[1] < $rows[0].size
        $antinodes << new_antinode_1
      end
      if new_antinode_2[0] >= 0 && new_antinode_2[0] < $rows.size && new_antinode_2[1] >= 0 && new_antinode_2[1] < $rows[0].size
        $antinodes << new_antinode_2
      end
    end
  end
  $antinodes.size
end

def part_2
  $antennas.each do |k,v|
    v.to_a.combination(2).each do |a,b|
      $antinodes << a
      $antinodes << b
      row_diff = (a[0] - b[0])
      col_diff = (a[1] - b[1])
      
      x = a[0] - row_diff
      y = a[1] - col_diff
      loop do
        if x >= 0 && x < $rows.size && y >= 0 && y < $rows[0].size
          $antinodes << [x,y]
        else
          break
        end
        x -= row_diff
        y -= col_diff
      end

      x = a[0] + row_diff
      y = a[1] + col_diff
      loop do
        if x >= 0 && x < $rows.size && y >= 0 && y < $rows[0].size
          $antinodes << [x,y]
        else
          break
        end
        x += row_diff
        y += col_diff
      end
    end
  end
  $antinodes.size
end

p "Part 1: #{part_1}"
p "Part 2: #{part_2}"