data = File.read("data/day_9.txt").lines.map(&:strip)

$data = data.first.chars.map(&:to_i)

$open_representation = []
$nil_locations_and_sizes = []
$file_locations_and_sizes = []

file = true
current_id = 0
$data.each do |num|
  if file
    $file_locations_and_sizes << [$open_representation.size, num, current_id]
    num.times do
      $open_representation << current_id
    end
    current_id += 1
    file = false
  else
    $nil_locations_and_sizes << [$open_representation.size, num]
    num.times do
      $open_representation << nil
    end
    file = true
  end
end

$nil_locations_and_sizes.reject! { |a| a[1] <= 0 }
$file_locations_and_sizes.reject! { |a| a[1] <= 0 }
original_open_representation = $open_representation.dup

def part_1
  nil_indexes = []
  $open_representation.each_with_index do |num, index|
    if num.nil?
      nil_indexes << index
    end
  end
  
  nil_indexes.each do |index|
    last_el = nil
    loop do
      last_el = $open_representation.pop
      break if !last_el.nil?
    end
    $open_representation[index] = last_el
  end
  $open_representation.compact!
  
  checksum = 0
  $open_representation.each_with_index do |num, index|
    checksum += num*index
  end
  checksum
end

def part_2
  $nil_locations_and_sizes.sort_by! { |a| a[1] }
  $file_locations_and_sizes.reverse.each do |file|
    # p $open_representation.map { |a| a.nil? ? "." : a }.join
    # p $nil_locations_and_sizes.sort_by { |a| a[0] }
    file_size = file[1]
    location = nil
    nil_index = nil
    $nil_locations_and_sizes.each_with_index do |nil_location, index|
      if nil_location[1] >= file_size && nil_location[0] < file[0]
        location = nil_location[0]
        nil_index = index
        break
      end
    end
    if location
      file_size.times do |i|
        $open_representation[location + i] = file[2]
        $open_representation[file[0] + i] = nil
      end
      $nil_locations_and_sizes[nil_index] = [$nil_locations_and_sizes[nil_index][0] + file_size, $nil_locations_and_sizes[nil_index][1] - file_size]
    end
    $nil_locations_and_sizes.reject! { |a| a[0] > file[0] }
    $nil_locations_and_sizes.reject! { |a| a[1] <= 0 }
    $nil_locations_and_sizes.sort_by! { |a| a[1] }
  end
  checksum = 0
  $open_representation.each_with_index do |num, index|
    if num.nil?
      checksum += 0
    else
      checksum += num*index
    end
  end
  checksum
end

p "Part 1: #{part_1}"
$open_representation = original_open_representation
p "Part 2: #{part_2}"