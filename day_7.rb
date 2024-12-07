data = File.read("data/day_7.txt").lines.map(&:strip)

equations = data.map do |line|
  line.split
end

def part_1(equations)
  total = 0
  equations.each do |equation|
    target = equation[0].chomp(":").to_i
    operands = equation[1..-1].map(&:to_i)
    sums_so_far = []
    operands.each do |operand|
      if sums_so_far.empty?
        sums_so_far << operand
        next
      end
      
      new_sums = []
      sums_so_far.each do |sum|
        next if sum > target
        new_sums << sum + operand
        new_sums << sum * operand
      end
      sums_so_far = new_sums
    end
    total += target if sums_so_far.include?(target)
  end
  total
end

def part_2(equations)
  total = 0
  equations.each do |equation|
    target = equation[0].chomp(":").to_i
    operands = equation[1..-1].map(&:to_i)
    sums_so_far = []
    operands.each do |operand|
      if sums_so_far.empty?
        sums_so_far << operand
        next
      end
      
      new_sums = []
      sums_so_far.each do |sum|
        next if sum > target
        new_sums << sum + operand
        new_sums << sum * operand
        new_sums << (sum.to_s + operand.to_s).to_i
      end
      sums_so_far = new_sums
    end
    total += target if sums_so_far.include?(target)
  end
  total
end

p "Part 1 : #{part_1(equations)}"
p "Part 2 : #{part_2(equations)}"