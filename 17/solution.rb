require 'algorithms'

lines = File.readlines('input.txt', chomp: true)
BOARD = lines.map { |line| line.split('').map(&:to_i) }

UP = :up
RIGHT = :right
DOWN = :down
LEFT = :left

DIRECTIONS = {
  UP => ->(x,y) { [x - 1, y] },
  RIGHT => ->(x,y) { [x, y + 1] },
  DOWN => ->(x,y) { [x + 1, y] },
  LEFT => ->(x,y) { [x, y - 1] },
}

Point = Struct.new(:pos, :weight, :visited, :directions)

def neighbors(point, board)
  x, y = point.pos

  allowed_directions = if point.directions.count == 3 && point.directions.uniq.count == 1
    last = point.directions.last
    if last == UP || last == DOWN
      [RIGHT, LEFT]
    else
      [UP, DOWN]
    end
  else
    [UP, RIGHT, DOWN, LEFT]
  end

  allowed_directions.filter do |dir|
    i, j = DIRECTIONS[dir].(x,y)

    i >= 0 && j >= 0 &&
      i < board.length && j < board[0].length &&
      !point.visited.include?([i,j])
  end.map do |dir|
    i, j = DIRECTIONS[dir].(x,y)
    Point.new([i,j],
              board[i][j] + point.weight,
              point.visited + [[i,j]],
              point.directions.last(2) + [dir])
  end
end

def find_minimal_path(start_pos, final_pos, board)
  visit_board = {}
  start_point = Point.new(start_pos, 0, [], [])

  queue = Containers::PriorityQueue.new
  queue.push(start_point, 0)

  while current_point = queue.pop  do
    if current_point.pos == final_pos
      return current_point.weight
    end

    key = [current_point.pos, current_point.directions]
    next if visit_board[key]
    visit_board[key] = current_point.weight

    neighbors = neighbors(current_point, board)
    neighbors.each do |neighbor|
      queue.push(neighbor, neighbor.weight * -1)
    end
  end
end

start_pos = [0,0]
final_pos = [BOARD.length - 1, BOARD[0].length - 1]

p res: find_minimal_path(start_pos, final_pos, BOARD)
