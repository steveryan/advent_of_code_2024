data = File.read("data/day_11.txt").lines.map(&:strip)

$stones = data.first.split(" ").map(&:to_i)

def part1
  75.times do |i|
    p "Round #{i+1}"
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
  end
  $stones.count
end

p "Part 1: #{part1}"