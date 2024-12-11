data = File.read("data/day_10.txt").lines.map(&:strip)

$data = data.map(&:chars)
$data = $data.map { |row| row.map(&:to_i)} 

$trailheads = []

$data.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    if cell == 0
      $trailheads << [x, y]
    end
  end
end

def part_1
  total = 0
  $trailheads.each do |trailhead|
    trailhead_score = 0
    possible = [trailhead]
    for i in 1..9
      new_possible = []
      possible.each do |point|
        next_from_point = (find_next_possible(point,i))
        new_possible += next_from_point
      end
      possible = new_possible.uniq
    end
    trailhead_score = possible.length
    total += trailhead_score
  end
  total
end

def find_next_possible(point, i)
  x, y = point
  possible = []
  if x + 1 < $data.length
    possible << [x + 1, y] if $data[x + 1][y] == i
  end
  if x - 1 >= 0
    possible << [x - 1, y] if $data[x - 1][y] == i
  end
  if y + 1 < $data[0].length
    possible << [x, y + 1] if $data[x][y + 1] == i
  end
  if y - 1 >= 0
    possible << [x, y - 1] if $data[x][y - 1] == i
  end
  possible
end

class Path
  attr_accessor :ending_point, :starting_point, :points

  def initialize(starting_point)
    @starting_point = starting_point
    @ending_point = starting_point
    @points = [starting_point]
  end

  def new_from_points(points)
    starting_point = points[0]
    path = Path.new(starting_point)
    for i in 1..points.length - 1
      path.add_point(points[i])
    end
    path
  end

  def add_point(point)
    @points << point
    @ending_point = point
  end

  def to_s
    "Path from #{@starting_point} to #{@ending_point}: #{@points}"
  end
end

def part_2
  total = 0
  $trailheads.each do |trailhead|
    paths_from_trailhead = [Path.new(trailhead)]
    trailhead_rating = 0
    possible = [trailhead]
    for i in 1..9
      new_possible = []
      possible.each do |point|
        next_from_point = (find_next_possible(point,i))
        new_possible += next_from_point

        new_paths = []
        for path in paths_from_trailhead
          if path.ending_point == point
            for next_point in next_from_point
              new_path = path.new_from_points(path.points)
              new_path.add_point(next_point)
              new_paths << new_path
            end
          end
        end
        paths_from_trailhead += new_paths
      end
      paths_from_trailhead.reject! { |path| path.points.length < i+1 }
      possible = new_possible.uniq
    end
    paths_from_trailhead.reject! { |path| path.points.length < 10 }
    path_set = Set.new
    paths_from_trailhead.each do |path|
      path_set << path.points
    end
    trailhead_rating = path_set.length
    total += trailhead_rating
  end
  total
end

p "Part 1: #{part_1}"
start_time = Time.now
p "Part 2: #{part_2}"
end_time = Time.now
p "Time: #{end_time - start_time}"