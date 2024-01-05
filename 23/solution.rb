Path = Struct.new(:current_pos, :steps)

UP = :up
RIGHT = :right
DOWN = :down
LEFT = :left

DIRECTIONS = {
  UP => ->(x,y) { [x - 1, y] },
  RIGHT => ->(x,y) { [x, y + 1] },
  DOWN => ->(x,y) { [x + 1, y] },
  LEFT => ->(x,y) { [x, y - 1] }
}

def neighbors(path, board)
  current_tile = board[path.current_pos[0]][path.current_pos[1]]

  allowed_directions = case current_tile
                       when '>'
                         [RIGHT]
                       when '<'
                         [LEFT]
                       when 'v'
                         [DOWN]
                       when '^'
                         [UP]
                       else
                         [UP, RIGHT, DOWN, LEFT]
                       end

  allowed_directions.map do |dir|
    DIRECTIONS[dir].(path.current_pos[0], path.current_pos[1])
  end.filter do |(i, j)|
    i >= 0 && j >= 0 &&
      i < board.length && j < board[0].length &&
      board[i][j] != '#' &&
      !path.steps.include?([i,j])
  end
end

lines = File.readlines('input.txt', chomp: true)
board = lines.map { _1.split('') }

start_pos = [0,1]
finish_pos = [board.length - 1, board[0].length - 2]
max_steps = 0

queue = [Path.new(start_pos, [start_pos])]

while e = queue.shift do
  if e.current_pos == finish_pos
    if max_steps < e.steps.count
      max_steps = e.steps.count
    end
  else
    neighbors(e, board).each do |neighbor|
      queue << Path.new(neighbor, e.steps + [neighbor])
    end
  end
end

p max: max_steps - 1