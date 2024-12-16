data = File.read("data/day_15.txt").lines.map(&:strip)

$grid = []
$instructions = []
$robot_position = nil
$walls = {}
$boxes = {}

blank_line = false
data.each do |line|
  if line == ""
    blank_line = true
    next
  end

  unless blank_line
    $grid << line.chars
  else
    $instructions << line.chars
  end
end

$instructions.flatten!

$grid.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    if cell == "@"
      $robot_position = [i, j]
    elsif cell == "#"
      $walls[[i, j]] = true
    elsif cell == "O"
      $boxes[[i, j]] = true
    end
  end
end

def part_1
  $instructions.each do |instruction|
    case instruction
    when "<"
      $robot_position[1] -= 1 if can_move?($robot_position, instruction)
    when ">"
      $robot_position[1] += 1 if can_move?($robot_position, instruction)
    when "^"
      $robot_position[0] -= 1 if can_move?($robot_position, instruction)
    when "v"
      $robot_position[0] += 1 if can_move?($robot_position, instruction)
    end
  end
  $boxes.filter! { |k, v| v }.sort { |a, b| a[0] <=> b[0] }
  score = $boxes.map { |k, v| k[0] * 100 + k[1] }.sum
  score
end


def can_move?(position, direction)
  x, y = position
  case direction
  when "<"
    if $walls[[x, y-1]]
      false
    else
      if $boxes[[x, y-1]]
        if can_move?([x, y-1], direction)
          $boxes[[x, y-1]] = false
          $boxes[[x, y-2]] = true
          true
        else
          false
        end
      else
        true
      end
    end
  when ">"
    if $walls[[x, y+1]]
      false
    else
      if $boxes[[x, y+1]]
        if can_move?([x, y+1], direction)
          $boxes[[x, y+1]] = false
          $boxes[[x, y+2]] = true
          true
        else
          false
        end
      else
        true
      end
    end
  when "^"
    if $walls[[x-1, y]]
      false
    else
      if $boxes[[x-1, y]]
        if can_move?([x-1, y], direction)
          $boxes[[x-1, y]] = false
          $boxes[[x-2, y]] = true
          true
        else
          false
        end
      else
        true
      end
    end
  when "v"
    if $walls[[x+1, y]]
      false
    else
      if $boxes[[x+1, y]]
        if can_move?([x+1, y], direction)
          $boxes[[x+1, y]] = false
          $boxes[[x+2, y]] = true
          true
        else
          false
        end
      else
        true
      end
    end
  end
end

p "Part 1: #{part_1}"

$grid_2 = $grid.map do |row|
  row.map do |cell|
    if cell == "@"
      "@.".chars
    elsif cell == "#"
      "##".chars
    elsif cell == "O"
      "[]".chars
    elsif cell == "."
      "..".chars
    end
  end
end

$grid_2.map! do |row|
  row.flatten!
end

$robot_position = nil
$walls = {}
$left_boxes = {}
$right_boxes = {}
$grid_2.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    if cell == "@"
      $robot_position = [i, j]
    elsif cell == "#"
      $walls[[i, j]] = true
    elsif cell == "["
      $left_boxes[[i, j]] = true
    elsif cell == "]"
      $right_boxes[[i, j]] = true
    end
  end
end

def part_2
  $instructions.each do |instruction|
    case instruction
    when "<"
      $robot_position[1] -= 1 if can_move_2?($robot_position, instruction)
    when ">"
      $robot_position[1] += 1 if can_move_2?($robot_position, instruction)
    when "^"
      $robot_position[0] -= 1 if can_move_2?($robot_position, instruction)
    when "v"
      $robot_position[0] += 1 if can_move_2?($robot_position, instruction)
    end
  end

  $left_boxes.filter! { |k, v| v }.sort { |a, b| a[0] <=> b[0] }
  $right_boxes.filter! { |k, v| v }.sort { |a, b| a[0] <=> b[0] }

  # (0...$grid_2.length).each do |i|
  #   line = ""
  #   (0...$grid_2[0].length).each do |j|
  #     if $walls[[i, j]]
  #       line += "#"
  #     elsif $left_boxes[[i, j]]
  #       line += "["
  #     elsif $right_boxes[[i, j]]
  #       line += "]"
  #     else
  #       line += "."
  #     end
  #   end
  #   p line
  # end
  score = $left_boxes.map { |k, v| k[0] * 100 + k[1] }.sum
  score
end
# not implemented yet
def can_move_2?(position,instruction)
  x, y = position
  case instruction
  when "<"
    if $walls[[x, y-1]]
      false
    else
      if $right_boxes[[x, y-1]]
        if can_move_2?([x, y-2], instruction)
          $right_boxes[[x, y-1]] = false
          $left_boxes[[x, y-2]] = false
          $right_boxes[[x, y-2]] = true
          $left_boxes[[x, y-3]] = true
          true
        else
          false
        end
      else
        true
      end
    end
  when ">"
    if $walls[[x, y+1]]
      false
    else
      if $left_boxes[[x, y+1]]
        if can_move_2?([x, y+2], instruction)
          $left_boxes[[x, y+1]] = false
          $left_boxes[[x, y+2]] = true
          $right_boxes[[x, y+2]] = false
          $right_boxes[[x, y+3]] = true
          true
        else
          false
        end
      else
        true
      end
    end
  when "^"
    if $walls[[x-1, y]]
      false
    elsif $right_boxes[[x-1, y]]
      if can_move_double_box_up?([x-1, y-1], [x-1, y])
        $right_boxes[[x-1, y]] = false
        $left_boxes[[x-1, y-1]] = false
        $right_boxes[[x-2, y]] = true
        $left_boxes[[x-2, y-1]] = true
        true
      else
        false
      end
    elsif $left_boxes[[x-1, y]]
      if can_move_double_box_up?([x-1, y], [x-1, y+1])
        $left_boxes[[x-1, y]] = false
        $right_boxes[[x-1, y+1]] = false
        $left_boxes[[x-2, y]] = true
        $right_boxes[[x-2, y+1]] = true
        true
      else
        false
      end
    else
      true
    end
  when "v"
    if $walls[[x+1, y]]
      false
    elsif $right_boxes[[x+1, y]]
      if can_move_double_box_down?([x+1, y-1], [x+1, y])
        $right_boxes[[x+1, y]] = false
        $left_boxes[[x+1, y-1]] = false
        $right_boxes[[x+2, y]] = true
        $left_boxes[[x+2, y-1]] = true
        true
      else
        false
      end
    elsif $left_boxes[[x+1, y]]
      if can_move_double_box_down?([x+1, y], [x+1, y+1])
        $left_boxes[[x+1, y]] = false
        $right_boxes[[x+1, y+1]] = false
        $left_boxes[[x+2, y]] = true
        $right_boxes[[x+2, y+1]] = true
        true
      else
        false
      end
    else
      true
    end
  end
end

def can_move_double_box_up?(position1, position2)
  x1, y1 = position1
  x2, y2 = position2
  left_can_move_up = true
  right_can_move_up = true
  if $walls[[x1-1, y1]] || $walls[[x2-1, y2]]
    return false
  end
  if $right_boxes[[x1-1, y1]]
    if can_move_double_box_up?([x1-1, y1-1], [x1-1, y1])
      left_can_move_up = true
    else
      return false
    end
  end
  if $left_boxes[[x2-1, y2]]
    if can_move_double_box_up?([x2-1, y2], [x2-1, y2+1])
      right_can_move_up = true
    else
      return false
    end
  end
  if $left_boxes[[x1-1, y1]] && $right_boxes[[x2-1, y2]]
    if can_move_double_box_up?([x1-1, y1], [x2-1, y2])
      $left_boxes[[x1-1, y1]] = false
      $right_boxes[[x2-1, y2]] = false
      $left_boxes[[x1-2, y1]] = true
      $right_boxes[[x2-2, y2]] = true
      return true
    else
      return false
    end
  end
  if left_can_move_up && right_can_move_up
    if $left_boxes[[x2-1, y2]]
      $left_boxes[[x2-1, y2]] = false
      $right_boxes[[x2-1, y2+1]] = false
      $left_boxes[[x2-2, y2]] = true
      $right_boxes[[x2-2, y2+1]] = true
    end
    if $right_boxes[[x1-1, y1]]
      $right_boxes[[x1-1, y1]] = false
      $left_boxes[[x1-1, y1-1]] = false
      $right_boxes[[x1-2, y1]] = true
      $left_boxes[[x1-2, y1-1]] = true
    end
    return true
  end
end

def can_move_double_box_down?(position1, position2)
  x1, y1 = position1
  x2, y2 = position2
  left_can_move_down = true
  right_can_move_down = true
  if $walls[[x1+1, y1]] || $walls[[x2+1, y2]]
    return false
  end
  if $right_boxes[[x1+1, y1]]
    if can_move_double_box_down?([x1+1, y1-1], [x1+1, y1])
      left_can_move_down = true
    else
      return false
    end
  end
  if $left_boxes[[x2+1, y2]]
    if can_move_double_box_down?([x2+1, y2], [x2+1, y2+1])
      right_can_move_down = true
    else
      return false
    end
  end
  if $left_boxes[[x1+1, y1]] && $right_boxes[[x2+1, y2]]
    if can_move_double_box_down?([x1+1, y1], [x2+1, y2])
      $left_boxes[[x1+1, y1]] = false
      $right_boxes[[x2+1, y2]] = false
      $left_boxes[[x1+2, y1]] = true
      $right_boxes[[x2+2, y2]] = true
      return true
    else
      return false
    end
  end
  if left_can_move_down && right_can_move_down
    if $left_boxes[[x2+1, y2]]
      $left_boxes[[x2+1, y2]] = false
      $right_boxes[[x2+1, y2+1]] = false
      $left_boxes[[x2+2, y2]] = true
      $right_boxes[[x2+2, y2+1]] = true
    end
    if $right_boxes[[x1+1, y1]]
      $right_boxes[[x1+1, y1]] = false
      $left_boxes[[x1+1, y1-1]] = false
      $right_boxes[[x1+2, y1]] = true
      $left_boxes[[x1+2, y1-1]] = true
    end
    return true
  end
end


p "Part 2: #{part_2}"
