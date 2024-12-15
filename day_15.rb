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

  # $boxes.filter! { |k, v| v }.sort { |a, b| a[0] <=> b[0] }
  # score = $boxes.map { |k, v| k[0] * 100 + k[1] }.sum
  # score
  nil
end
# not implemented yet
# def can_move_2?(position,instruction)
#   x, y = position
#   case direction
#   when "<"
#     if $walls[[x, y-1]]
#       false
#     else
#       if $right_boxes[[x, y-1]]
#         if can_move?([x, y-2], direction)
#           $right_boxes[[x, y-1]] = false
#           $left_boxes[[x, y-2]] = false
#           $right_boxes[[x, y-2]] = true
#           $left_boxes[[x, y-3]] = true
#           true
#         else
#           false
#         end
#       else
#         true
#       end
#     end
#   when ">"
#     if $walls[[x, y+1]]
#       false
#     else
#       if $left_boxes[[x, y+1]]
#         if can_move?([x, y+2], direction)
#           $left_boxes[[x, y+1]] = false
#           $left_boxes[[x, y+2]] = true
#           $right_boxes[[x, y+2]] = false
#           $right_boxes[[x, y+3]] = true
#           true
#         else
#           false
#         end
#       else
#         true
#       end
#     end
#   when "^"
#     if $walls[[x-1, y]]
#       false
#     else
#       if $left_boxes[[x-1, y]]
#         if can_move?([x-1, y], direction) && can_move?([x-1, y+1], direction)
          

#           $boxes[[x-2, y]] = true
#           true
#         else
#           false
#         end
#       else
#         true
#       end
#     end
#   when "v"
#     if $walls[[x+1, y]]
#       false
#     else
#       if $boxes[[x+1, y]]
#         if can_move?([x+1, y], direction)
#           $boxes[[x+1, y]] = false
#           $boxes[[x+2, y]] = true
#           true
#         else
#           false
#         end
#       else
#         true
#       end
#     end
#   end
# end
