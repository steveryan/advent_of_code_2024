data = File.read("data/day_11.txt").lines.map(&:strip)

$stones = data.first.split(" ").map(&:to_i)
$original_stones = $stones

def part1
  25.times do |i|
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

def part2_recursive
  start = Time.now
  $stones = $original_stones
  final_stones = 0
  $stones.each_with_index do |stone,i|
    stone_start = Time.now
    final_stones += split(stone,5000)
  end
  p "Time: #{Time.now - start}"
  final_stones
end

$cache = {}
def split(stone,times)
  key = "#{stone}_#{times}"
  if $cache[key]
    return $cache[key]
  end
  if times == 0
    $cache[key] = 1
  else
    if stone == 0
      $cache[key] = split(1,times-1)
    elsif stone.to_s.chars.count.even?
      chars = stone.to_s.chars
      count = chars.count
      first_value = chars[0...count/2].join.to_i
      second_value = chars[count/2..-1].join.to_i
      $cache[key] = split(first_value,times-1) + split(second_value,times-1)
    else
      $cache[key] = split(stone * 2024,times-1)
    end
    $cache[key]
  end
end

$bottom_up_cache = {}
def part2_bottom_up
  start = Time.now
  3000.times do |i|
    100.times do |j|
      bottom_up_split(j,i)
    end
  end
  p "cache built: #{Time.now - start}"
  $stones = $original_stones
  final_stones = 0
  $call_count = 0
  $cache_hit_count = 0
  $stones.each do |stone|
    final_stones += bottom_up_split(stone,3000)
  end
  p "Finished: #{Time.now - start}"
  final_stones
end

$call_count = 0
$cache_hit_count = 0
def bottom_up_split(stone,times)
  $call_count += 1
  key = "#{stone}_#{times}"
  if $bottom_up_cache[key]
    $cache_hit_count += 1
    return $bottom_up_cache[key]
  end
  if times == 0
    $bottom_up_cache[key] = 1
  elsif stone == 0
      $bottom_up_cache[key] = bottom_up_split(1,times-1)
  elsif stone.to_s.chars.count.even?
    chars = stone.to_s.chars
    count = chars.count
    first_value = chars[0...count/2].join.to_i
    second_value = chars[count/2..-1].join.to_i
    $bottom_up_cache[key] = bottom_up_split(first_value,times-1) + bottom_up_split(second_value,times-1)
  else
    $bottom_up_cache[key] = bottom_up_split(stone * 2024,times-1)
  end
  $bottom_up_cache[key]
end

p part2_recursive
p part2_bottom_up 


p "percent of bottom up cache hits: #{100*$cache_hit_count.to_f / $call_count.to_f}"