# Helpers

def show_board(board)
  board.each do |line|
    line[0..175].each do |e|
      print e || '.'
    end
    print("\n")
  end
  p '-------'
end

UP = :up
RIGHT = :right
DOWN = :down
LEFT = :left

DIRECTIONS = {
  UP => ->(x,y) { [x - 1, y] },
  RIGHT => ->(x,y) { [x, y + 1] },
  DOWN => ->(x,y) { [x + 1,y] },
  LEFT => ->(x,y) { [x, y - 1] },
}

def neighbors(current_pos, board)
  [UP, RIGHT, DOWN, LEFT].map do |dir|
    DIRECTIONS[dir].(current_pos[0], current_pos[1])
  end.filter do |(i, j)|
    i >= 0 && j >= 0 &&
      i < board.length && j < board[0].length &&
      board[i][j] != '#'
  end
end

def filled_neighbors(current_pos, board)
  [UP, RIGHT, DOWN, LEFT].map do |dir|
    DIRECTIONS[dir].(current_pos[0], current_pos[1])
  end.filter do |(i, j)|
    i >= 0 && j >= 0 &&
      i < board.length && j < board[0].length &&
      board[i][j] == '#'
  end
end

def bfs(start_pos, board)
  queue = [start_pos]

  while current_pos = queue.shift do
    if board[current_pos[0]][current_pos[1]] != '#'
      board[current_pos[0]][current_pos[1]] = '#'

      neighbors(current_pos, board).each { |neighbor| queue.push(neighbor) }
    end
  end
end

# Read steps

lines = File.readlines('input.txt', chomp: true)
STEPS = lines.map do |line|
  direction, number, color = line.split(' ')
  number = number.to_i
  color = color[1..-2]

  [direction, number, color]
end

# Expand field to have enough place

ups = 1
downs = 1
rights = 1
lefts = 1

STEPS.each do | step|
  case step[0]
  when 'U'
    ups += step[1]
  when 'R'
    rights += step[1]
  when 'D'
    downs += step[1]
  when 'L'
    lefts += step[1]
  end
end

# Fill with path
max_height = ups + downs
max_width = rights + lefts

board = Array.new(max_height) { Array.new(max_width) }

current_pos = [ups, lefts]
board[current_pos[0]][current_pos[1]] = '#'
STEPS.each_with_index  do |step, i|
  filler = '#'
  case step[0]
  when 'U'
    step[1].times do |i|
      board[current_pos[0] - i - 1][current_pos[1]] = filler
    end
    current_pos[0] -= step[1]
  when 'R'
    step[1].times do |i|
      board[current_pos[0]][current_pos[1] + i + 1] = filler
    end
    current_pos[1] += step[1]
  when 'D'
    step[1].times do |i|
      board[current_pos[0] + i + 1][current_pos[1]] = filler
    end
    current_pos[0] += step[1]
  when 'L'
    step[1].times do |i|
      board[current_pos[0]][current_pos[1] - i - 1] = filler
    end
    current_pos[1] -= step[1]
  end
end

# show_board(board)

# Find right size of the field
left = board[0].length - 1
right = 0
up = board.length - 1
down = 0

board.each_with_index do |line, i|
  line.each_with_index do |e, j|
    if e == '#'
      up = i if i < up
      down = i if i > down
      right = j if j > right
      left = j if j < left
    end
  end
end

new_board = []
board[up..down].each do |line|
  new_board << line[left..right]
end
board = new_board


# show_board(board)
# exit

# find internal point
internal_point = []
flag = nil

board[1].each_with_index do |e, j|
  if e != '#' && flag
    internal_point = [1, j]
    break
  end
  if e == '#'
    flag = true
  end
end

# fill all internals

bfs(internal_point, board)
# show_board(board)

# calculate marked points

count = 0
board.each_with_index do |line, i|
  line.each_with_index do |e, j|
    if e == '#'
      count += 1
    end
  end
end
p count
