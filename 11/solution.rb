lines = File.readlines('input.txt', chomp: true)
board = []
rows_with_galaxies = []
columns_with_galaxies = []
galaxies = []
lines.each_with_index do |line, i|
  line_points = line.split('')
  board << line_points
  line_points.each_with_index do |point,j|
    if point == '#'
      rows_with_galaxies << i
      columns_with_galaxies << j
      galaxies << [i,j]
    end
  end
end
empty_rows = (0..board.length-1).to_a - rows_with_galaxies
empty_columns = (0..board[0].length-1).to_a - columns_with_galaxies

total_dist = 0

EXPAND_COEF = 2 # 1_000_000

galaxies.each_with_index do |galaxy1, i|
  galaxies.each_with_index do |galaxy2, j|
    next if i <= j

    g1x, g2x = [galaxy1[0], galaxy2[0]].sort
    g1y, g2y = [galaxy1[1], galaxy2[1]].sort

    dist = (g2x - g1x) +
      (g2y - g1y) +
      (g1x..g2x).count {|x| empty_rows.include?(x) } * (EXPAND_COEF - 1) +
      (g1y..g2y).count {|x| empty_columns.include?(x) } * (EXPAND_COEF - 1)

    total_dist += dist
  end
end

p total_dist

