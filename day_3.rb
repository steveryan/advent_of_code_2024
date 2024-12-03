data = File.read("data/day_3.txt")


def part_1(data)
  total = 0
  data = data.split("mul(")
  data = data.map do |x|
    x.split(")")[0]
  end
  data.each do |datum|
    if datum.match?(/[0-9]+,[0-9]+$/)
      total += (datum.split(",")[0].to_i * datum.split(",")[1].to_i)
    end
  end
  total
end

def part_2(data)
  array = []
  while index = data.index("don't()") do
    array << data.slice!(0..index)
    if do_index = data.index("do()")
      data = data[do_index..-1]
    else
      data = []
    end
  end
  array << data
  part_1(array.join)
end

p "Part 1: #{part_1(data)}"
p "Part 2: #{part_2(data)}"