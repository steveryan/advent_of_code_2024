rows = File.read("data/day_4.txt").lines.map(&:strip).map(&:chars)

def part_1(rows)
  total = 0
  for i in 0...rows.length
    for j in 0...rows[i].length
      if rows[i][j] == "X"
        total += 1 if up?(rows, i, j)
        total += 1 if down?(rows, i, j)
        total += 1 if left?(rows, i, j)
        total += 1 if right?(rows, i, j)
        total += 1 if up_left?(rows, i, j)
        total += 1 if up_right?(rows, i, j)
        total += 1 if down_left?(rows, i, j)
        total += 1 if down_right?(rows, i, j)
      end
    end
  end
  total
end

def up?(rows, i, j)
  return false if i < 3
  return false unless rows[i - 1][j] == "M"
  return false unless rows[i - 2][j] == "A"
  return false unless rows[i - 3][j] == "S"
  return true
end

def down?(rows, i, j)
  return false if i > rows.length - 4
  return false unless rows[i + 1][j] == "M"
  return false unless rows[i + 2][j] == "A"
  return false unless rows[i + 3][j] == "S"
  return true
end

def left?(row, i, j)
  return false if j < 3
  return false unless row[i][j - 1] == "M"
  return false unless row[i][j - 2] == "A"
  return false unless row[i][j - 3] == "S"
  return true
end

def right?(row, i, j)
  return false if j > row.length - 4
  return false unless row[i][j + 1] == "M"
  return false unless row[i][j + 2] == "A"
  return false unless row[i][j + 3] == "S"
  return true
end

def up_left?(rows, i, j)
  return false if i < 3 || j < 3
  return false unless rows[i - 1][j - 1] == "M"
  return false unless rows[i - 2][j - 2] == "A"
  return false unless rows[i - 3][j - 3] == "S"
  return true
end

def up_right?(rows, i, j)
  return false if i < 3 || j > rows[i].length - 4
  return false unless rows[i - 1][j + 1] == "M"
  return false unless rows[i - 2][j + 2] == "A"
  return false unless rows[i - 3][j + 3] == "S"
  return true
end

def down_left?(rows, i, j)
  return false if i > rows.length - 4 || j < 3
  return false unless rows[i + 1][j - 1] == "M"
  return false unless rows[i + 2][j - 2] == "A"
  return false unless rows[i + 3][j - 3] == "S"
  return true
end

def down_right?(rows, i, j)
  return false if i > rows.length - 4 || j > rows[i].length - 4
  return false unless rows[i + 1][j + 1] == "M"
  return false unless rows[i + 2][j + 2] == "A"
  return false unless rows[i + 3][j + 3] == "S"
  return true
end

p "Part 1: #{part_1(rows)}"

def part_2(rows)
  total = 0
  for i in 0...rows.length
    for j in 0...rows[i].length
      if rows[i][j] == "A"
        total += 1 if x?(rows,i,j)
      end
    end
  end
  total
end

def x?(rows,i,j)
  found = 0
  return false if i == 0 || i == rows.length - 1
  return false if j == 0 || j == rows[i].length - 1
  
  found += 1 if ((rows[i - 1][j - 1] == "M" && rows[i + 1][j + 1] == "S") ||
    (rows[i - 1][j - 1] == "S" && rows[i + 1][j + 1] == "M")) &&
    ((rows[i - 1][j + 1] == "M" && rows[i + 1][j - 1] == "S") ||
    (rows[i - 1][j + 1] == "S" && rows[i + 1][j - 1] == "M"))

  return true if found > 0
  false
end

p "Part 2: #{part_2(rows)}"