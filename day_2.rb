data = File.read("data/day_2.txt").lines.map(&:strip)

reports = data.map do |line|
  line.split(" ").map(&:to_i)
end

def part_1(reports)
  safe_count = 0
  reports.each do |report|
    report_safe = true
    direction = if report[0] < report [1]
      :increasing 
    else 
      :decreasing
    end
    for i in 1..report.length - 1
      if direction == :increasing
        if report[i] <= report[i - 1]
          report_safe = false
          break
        end
      else
        if report[i] >= report[i - 1]
          report_safe = false
          break
        end
      end
      if (report[i] - report[i - 1]).abs > 3
        report_safe = false
        break
      end
    end
    safe_count += 1 if report_safe
  end
  safe_count
end

def part_2(reports)
  safe_count = 0
  reports.each do |report|
    if valid_report?(report: report, dampener_used: false)
      safe_count += 1
    end
  end
  safe_count
end

def valid_report?(report:, dampener_used:)
  report_safe = true
  direction = if report[0] < report [1]
    :increasing 
  else 
    :decreasing
  end
  for i in 1..report.length - 1
    if direction == :increasing
      if report[i] <= report[i - 1]
        report_safe = false
        break
      end
    else
      if report[i] >= report[i - 1]
        report_safe = false
        break
      end
    end
    if (report[i] - report[i - 1]).abs > 3
      report_safe = false
      break
    end
  end
  report_safe
end

p "Part 1: #{part_1(reports)}"
p "Part 2: #{part_2(reports)}"