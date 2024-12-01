data = File.read("data/day_1.txt").lines.map(&:strip)

list_1 = []
list_2 = []
list2_counts = {}
data.each do |x|
  components = x.split(" ")
  list_1 << components[0].to_i
  list_2 << components[1].to_i
  if list2_counts[components[1].to_i].nil?
    list2_counts[components[1].to_i] = 1
  else
    list2_counts[components[1].to_i] += 1
  end
end

def part_1(list_1, list_2)
  list_1.sort!
  list_2.sort!
  total_difference = 0
  for i in 0..list_1.length - 1
    difference = list_1[i] - list_2[i]
    total_difference += difference.abs
  end
  total_difference
end

def part_2(list_1, list2_counts)
  similarity_score = 0
  list_1.each do |x|
    if list2_counts[x]
      similarity_score += x * list2_counts[x]
    end
  end
  similarity_score
end

p "Part 1: #{part_1(list_1, list_2)}"
p "Part 2: #{part_2(list_1, list2_counts)}"