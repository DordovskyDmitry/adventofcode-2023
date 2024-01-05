MOVES = {
  '|' => ->(x, y) { [[x - 1, y], [x + 1, y]] },
  '-' => ->(x, y) { [[x, y - 1], [x, y + 1]] },
  'L' => ->(x, y) { [[x - 1, y], [x, y + 1]] },
  'J' => ->(x, y) { [[x - 1, y], [x, y - 1]] },
  '7' => ->(x, y) { [[x, y - 1], [x + 1, y]] },
  'F' => ->(x, y) { [[x, y + 1], [x + 1, y]] },
  '.' => []
}

def valid?(board, x,y)
  x>=0 && y >= 0 && x < board.length && y < board[0].length
end

def find_cycle_length(board, previous_pos, current_pos, l = 1)
  current_sym = board[current_pos[0]][current_pos[1]]

  while current_sym != 'S' do
    if current_sym == '.'
      return 0
    end

    next_positions = (MOVES[current_sym].call(*current_pos) - [previous_pos])
    if next_positions.count > 1
      return 0
    end

    next_pos = next_positions.first

    unless valid?(board, *next_pos)
      return 0
    end

    previous_pos = current_pos
    current_pos = next_pos
    current_sym = board[current_pos[0]][current_pos[1]]

    l+=1
  end

  l
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
  [s_pos[0],     s_pos[1] - 1],
  [s_pos[0],     s_pos[1] + 1],
  [s_pos[0] + 1, s_pos[1] - 1],
  [s_pos[0] + 1, s_pos[1]],
  [s_pos[0] + 1, s_pos[1] + 1]
].select { |(x,y)| valid?(board, x,y) }

p(s_neighbors.map do |neighbor|
  find_cycle_length(board, s_pos, neighbor)
end.max / 2)

