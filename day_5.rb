data = File.read("data/day_5.txt").lines.map(&:strip)

rules = {}
updates = []
data.each do |line|
  if line.include?("|")
    components = line.split("|").map(&:to_i)
    if rules[components[1]].nil?
      rules[components[1]] = [components[0]]
    else
      rules[components[1]] << components[0]
    end
  elsif line.include?(",")
    updates << line.split(",").map(&:to_i)
  end
end
$incorrect = []

def part_1(rules, updates)
  total = 0
  updates.each do |update|
    valid = true
    seen = {}
    update.each do |num|
      if rules[num].nil?
        seen[num] = true
      else
        rules[num].each do |rule|
          if seen[rule] || !update.include?(rule)
            seen[num] = true
            next
          else
            valid = false
            break
          end
        end
      end
    end
    if valid
      middle = update[(update.length / 2.0).floor]
      total += middle
    else
      $incorrect << update
    end
  end
  total
end

def find_first_incorrect_index(rules, update)
  incorrect_index = nil
  valid = true
  seen = {}
  update.each_with_index do |num, index|
    if rules[num].nil?
      seen[num] = true
    else
      rules[num].each do |rule|
        if seen[rule] || !update.include?(rule)
          seen[num] = true
          next
        else
          valid = false
          incorrect_index = index
          break
        end
      end
      break if !valid
    end
  end
  incorrect_index
end

def part_2(rules)
  total = 0
  corrected = []
  $incorrect.each do |update|
    while index = find_first_incorrect_index(rules, update)
      max_breaking_index = index
      rules[update[index]].each do |num|
        if i = update.find_index(num)
          if i > max_breaking_index
            max_breaking_index = i
          end
        end
      end
      update[max_breaking_index], update[index] = update[index], update[max_breaking_index]
    end
    middle = update[(update.length / 2.0).floor]
    total += middle
  end
  total
end

p "Part 1: #{part_1(rules, updates)}"
p "Part 2: #{part_2(rules)}"