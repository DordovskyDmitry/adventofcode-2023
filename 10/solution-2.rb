MOVES = {
  '|' => ->(x, y) { [[x - 1, y], [x + 1, y]] },
  '-' => ->(x, y) { [[x, y - 1], [x, y + 1]] },
  'L' => ->(x, y) { [[x - 1, y], [x, y + 1]] },
  'J' => ->(x, y) { [[x - 1, y], [x, y - 1]] },
  '7' => ->(x, y) { [[x, y - 1], [x + 1, y]] },
  'F' => ->(x, y) { [[x, y + 1], [x + 1, y]] },
  '.' => []
}

def valid?(board, x, y)
  x >= 0 && y >= 0 && x < board.length && y < board[0].length
end

def find_cycle(board, previous_pos, current_pos)
  current_sym = board[current_pos[0]][current_pos[1]]

  cycle = { previous_pos => current_pos }

  while current_sym != 'S' do
    if current_sym == '.'
      return []
    end

    next_postions = (MOVES[current_sym].call(*current_pos) - [previous_pos])
    if next_postions.count > 1
      return []
    end

    next_pos = next_postions.first

    unless valid?(board, *next_pos)
      return []
    end

    previous_pos = current_pos
    current_pos = next_pos
    current_sym = board[current_pos[0]][current_pos[1]]

    cycle.merge!(previous_pos => current_pos)
  end

  cycle
end

lines = File.readlines('input.txt', chomp: true)

board = []
s_pos = nil

lines.each_with_index do |line, i|
  line_points = line.split('')
  board << line_points
  s_y_pos = line_points.index('S')
  s_pos = [i, s_y_pos] if s_y_pos
end

s_neighbors = [
  [s_pos[0] - 1, s_pos[1] - 1],
  [s_pos[0] - 1, s_pos[1]],
  [s_pos[0] - 1, s_pos[1] + 1],
  [s_pos[0], s_pos[1] - 1],
  [s_pos[0], s_pos[1] + 1],
  [s_pos[0] + 1, s_pos[1] - 1],
  [s_pos[0] + 1, s_pos[1]],
  [s_pos[0] + 1, s_pos[1] + 1]
].select { |(x, y)| valid?(board, x, y) }

cycles = s_neighbors.map do |neighbor|
  find_cycle(board, s_pos, neighbor,)
end

biggest_cycle = cycles.max_by(&:length)

dots = []

board.each_with_index do |row, i|
  row.each_with_index do |e, j|
    if e == '.' || biggest_cycle[[i, j]].nil?
      board[i][j] = '.'
      dots << [i,j]
    end
  end
end

# Ray based algorithm (odd number of intersections in each direction)
acc = 0
cycle = biggest_cycle.keys
dots.each do |i, j|
  left_top_intersections = cycle.count do |x,y|
    x == i && y < j && %w[| L J].include?(board[x][y])
  end

  acc += 1 if left_top_intersections.odd?
end

p acc
