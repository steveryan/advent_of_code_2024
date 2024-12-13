data = File.read("data/day_13.txt").lines.map(&:strip)

data = data.map do |line|
  if line == ""
    "|"
  else
    line+";"
  end
end

data = data.join.split("|")

$a_buttons = []
$b_buttons = []
$prizes = []

data.each do |line|
  a,b,prize = line.split(";")
  a_x, a_y = a.split(",").map { |x| x.scan(/\d+/).first.to_i }
  b_x, b_y = b.split(",").map { |x| x.scan(/\d+/).first.to_i }
  prize_x, prize_y = prize.split(",").map { |x| x.scan(/\d+/).first.to_i }
  $a_buttons << [a_x, a_y]
  $b_buttons << [b_x, b_y]
  $prizes << [prize_x, prize_y]
end

$solutions = []
$costs = []

def part_1
  (0...$a_buttons.length).each do |i|
    a_x, a_y = $a_buttons[i]
    b_x, b_y = $b_buttons[i]
    prize_x, prize_y = $prizes[i]
    x_solutions = []
    (0..100).each do |j|
      a = j
      b = (prize_x - a*a_x) / b_x
      if (prize_x - a*a_x) % b_x == 0
        x_solutions << [a, b]
      end
    end
    x_solutions.each do |solution|
      if solution[0]*a_y + solution[1]*b_y == prize_y
        $solutions << solution
        $costs << 3*solution[0] + solution[1]
      end
    end
  end
  $costs.sum
end




def part_2
  $solutions = []
  $costs = []
  (0...$a_buttons.length).each do |i|
    a_x, a_y = $a_buttons[i]
    b_x, b_y = $b_buttons[i]
    prize_x, prize_y = $prizes[i]
    prize_x += 10000000000000
    prize_y += 10000000000000

    
    x_solutions = []
    b = (prize_y*a_x - a_y*prize_x)/(a_x*b_y - a_y*b_x)
    a = (prize_x - b*b_x) / a_x

    prize_x = prize_x.to_i
    prize_y = prize_y.to_i
    if (prize_x - b*b_x) % a_x == 0 && (prize_y - a*a_y) % b_y == 0
      x_solutions << [a, b]
    end
  
    x_solutions.each do |solution|
      if solution[0]*a_y + solution[1]*b_y == prize_y
        solution = solution.map(&:to_i)
        $solutions << solution
        $costs << 3*solution[0] + solution[1]
      end
    end
  end
  $costs.sum
end


p "Part 1: #{part_1}"
p "Part 2: #{part_2}"