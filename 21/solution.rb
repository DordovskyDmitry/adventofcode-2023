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

def possible_pos_count(board, start, steps)
  reached = [Set.new([start])]
  steps.times do |i|
    reached[i+1] = Set.new
    reached[i].each do |point|
      nbs = neighbors(point, board)
      nbs.each do |neighbor|
        reached[i+1].add neighbor
      end
    end
  end
  reached[steps].count
end

def task(file, steps)
  lines = File.readlines(file, chomp: true)
  board = lines.map { _1.split('') }

  s = nil
  board.each_with_index do |line, i|
    break if s
    line.each_with_index do |e, j|
      if e == 'S'
        s = [i, j]
        board[i][j] = '.'
        break
      end
    end
  end

  possible_pos_count(board, s, steps)
end

p test: task('test.txt', 6)
p task1: task('input.txt', 64)


