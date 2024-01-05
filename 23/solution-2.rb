Path = Struct.new(:current, :steps, :length)

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
  [UP, RIGHT, DOWN, LEFT].map do |dir|
    DIRECTIONS[dir].(path.current[0], path.current[1])
  end.filter do |(i, j)|
    i >= 0 && j >= 0 &&
      i < board.length && j < board[0].length &&
      board[i][j] != '#' &&
      !path.steps.include?([i,j])
  end
end

def continue_uniq_path(path, board, visited)
  loop do
    nbs = neighbors(path, board)
    if nbs.count == 1
      visited.add nbs.first
      path.current = nbs.first
      path.steps << nbs.first
    else
      break
    end
  end
  path
end

lines = File.readlines('input.txt', chomp: true)
board = lines.map { _1.split('') }

##############    build graph    ###############

visited = Set.new
nodes = {}

board.each_with_index do |line, i|
  line.each_with_index do |e, j|
    if e != '#' && !visited.include?([i,j])
      start_point = Path.new([i,j], [[i,j]])
      nbs = neighbors(start_point, board)
      if nbs.count == 2
        path1 = Path.new(nbs[0], [[i,j], nbs[0]])
        continue_uniq_path(path1, board, visited)

        path2 = Path.new(nbs[1], [[i,j], nbs[1]])
        continue_uniq_path(path2, board, visited)

        node1 = path1.steps[-1]
        node2 = path2.steps[-1]

        chain = path1.steps.reverse[1...-1] + path2.steps[0...-1]

        nodes[node1] ||= {}
        nodes[node1][node2] = chain.length + 1

        nodes[node2] ||= {}
        nodes[node2][node1] = chain.length + 1
      end
    end
  end
end

##############    BFS to calc max path    ###############

start = Path.new([0,1], [[0,1]], 0)

final_coords = [board.length - 1, board[0].length - 2]
max_length = 0
queue = [start]

while to_process = queue.shift
  if to_process.current == final_coords
    if max_length < to_process.length
      max_length = to_process.length
    end

    next
  end

  nodes[to_process.current].each do |neighbor, length|
    next if to_process.steps.include?(neighbor)

    queue << Path.new(neighbor, to_process.steps + [neighbor], to_process.length + length)
  end
end
p max_length
