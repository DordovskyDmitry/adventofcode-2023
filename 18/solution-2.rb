DIRECTIONS  = %w[R D L U]

lines = File.readlines('input.txt', chomp: true)
STEPS = lines.map do |line|
  _, _, color = line.split(' ')
  color = color[1..-2]

  direction = DIRECTIONS[color[-1].to_i]
  number = "0x#{color[1..-2]}".to_i(16)

  [direction, number]
end

origin = [0,0]
points = [origin]
current_point = origin
length = 0
STEPS.each do |d, n|
  length += n
  case d
  when 'R'
    current_point = [current_point[0] + n, current_point[1]]
  when 'D'
    current_point = [current_point[0], current_point[1] - n]
  when 'L'
    current_point = [current_point[0] - n, current_point[1]]
  when 'U'
    current_point = [current_point[0], current_point[1] + n]
  end
  points << current_point
end

points = points[0..-2]

# Use Gauss formula
l = points.size
area_from_cell_centers = (0..l-1).reduce(0) do |sum,i|
  sum + points[i][0] * (points[(i + 1) % l][1] - points[(i-1+l) % l][1])
end.abs / 2

external_area = length / 2 + 1 # Area to cover external halves of cells

p res: area_from_cell_centers + external_area
