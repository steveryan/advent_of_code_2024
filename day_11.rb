data = File.read("data/day_11.txt").lines.map(&:strip)

$stones = data.first.split(" ").map(&:to_i)
$original_stones = $stones

def part1
  75.times do |i|
    start = Time.now
    new_stones = []
    $stones.each do |stone|
      if stone == 0
        new_stones << 1
      elsif stone.to_s.chars.count.even?
        chars = stone.to_s.chars
        count = chars.count
        new_stones << chars[0...count/2].join.to_i
        new_stones << chars[count/2..-1].join.to_i
      else
        new_stones << stone * 2024
      end
    end
    $stones = new_stones
    if (i+1) == 25
      p "25: #{$stones.count}"
    end
  end_time = Time.now
  p "Round #{i+1} Time: #{end_time - start} Stones: #{$stones.count}"
  end
  $stones.count
end

def part2
  final_stones = []
  $stones = $original_stones
  $stones.each do |curr|
    stones = [curr]
    37.times do |i|
      new_stones = []
      stones.each do |stone|
        if stone == 0
          new_stones << 1
        elsif stone.to_s.chars.count.even?
          chars = stone.to_s.chars
          count = chars.count
          new_stones << chars[0...count/2].join.to_i
          new_stones << chars[count/2..-1].join.to_i
        else
          new_stones << stone * 2024
        end
      end
      stones = new_stones
    end
    final_stones << stones
  end
  final_stones.flatten.count
end

start = Time.now
p "Part 1: #{part1}"
end_time = Time.now
p "Time: #{end_time - start}"
# p "Part 2: #{part2}"
# part2_time = Time.now
# p "Time: #{part2_time - end_time}"
