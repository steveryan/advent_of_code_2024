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
  final_file_locations_and_sizes = []
  $file_locations_and_sizes.reverse.each do |file|
    file_size = file[1]
    location = nil
    nil_index = nil
    nil_locations_and_sizes_local = $nil_locations_and_sizes.dup
    nil_locations_and_sizes_local.each_with_index do |nil_location, index|
      if nil_location[1] >= file_size && nil_location[0] < file[0]
        location = nil_location[0]
        nil_index = index
        break
      end
    end
    if location
      final_file_locations_and_sizes << [location, file_size, file[2]]
      $nil_locations_and_sizes[nil_index] = [nil_locations_and_sizes_local[nil_index][0] + file_size, nil_locations_and_sizes_local[nil_index][1] - file_size]
    else
      final_file_locations_and_sizes << [file[0], file[1], file[2]]
    end
    $nil_locations_and_sizes.reject! { |a| a[0] > file[0] }
    $nil_locations_and_sizes.reject! { |a| a[1] <= 0 }
  end


  different_checksum = 0
  final_file_locations_and_sizes.each do |file|
    file_location_start = file[0]
    file_size = file[1]
    file_id = file[2]

    for i in file_location_start..file_location_start+file_size-1
      different_checksum += file_id*i
    end
  end
  different_checksum
end

p "Part 1: #{part_1}"
p "Part 2: #{part_2}"