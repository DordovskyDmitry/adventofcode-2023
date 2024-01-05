lines = File.readlines('input.txt', chomp: true)
BOARD = lines.map { |line| line.split('') }

UP = :up
RIGHT = :right
DOWN = :down
LEFT = :left

NEXT_DIRECTIONS = {
  [UP, '.'] => [UP],
  [RIGHT, '.'] => [RIGHT],
  [DOWN, '.'] => [DOWN],
  [LEFT, '.'] => [LEFT],

  [UP, '/'] => [RIGHT],
  [RIGHT, '/'] => [UP],
  [DOWN, '/'] => [LEFT],
  [LEFT, '/'] => [DOWN],

  [UP, '\\'] => [LEFT],
  [RIGHT, '\\'] => [DOWN],
  [DOWN, '\\'] => [RIGHT],
  [LEFT, '\\'] => [UP],

  [UP, '-'] => [RIGHT, LEFT],
  [RIGHT, '-'] => [RIGHT],
  [DOWN, '-'] => [RIGHT, LEFT],
  [LEFT, '-'] => [LEFT],

  [UP, '|'] => [UP],
  [RIGHT, '|'] => [UP, DOWN],
  [DOWN, '|'] => [DOWN],
  [LEFT, '|'] => [UP, DOWN],
}

Step = Struct.new(:pos, :direction)

def next_position(pos, direction, board)
  new_pos = pos.dup
  case direction
  when UP
    new_pos[0] -= 1
    if new_pos[0] >= 0
      new_pos
    end
  when RIGHT
    new_pos[1] += 1
    if new_pos[1] < board.length
      new_pos
    end
  when DOWN
    new_pos[0] += 1
    if new_pos[0] < board.length
      new_pos
    end
  when LEFT
    new_pos[1] -= 1
    if new_pos[1] >= 0
      new_pos
    end
  end
end

def next_steps(step, board)
  pos = step.pos
  value = board[pos[0]][pos[1]]
  next_dirs = NEXT_DIRECTIONS[[step.direction, value]]

  next_dirs.map do |dir|
    next_pos = next_position(pos, dir, board)
    if next_pos
      Step.new(next_pos, dir)
    end
  end.compact
end

def calc_energy(start_pos, direction, board)
  energized = Array.new(board.length) { Array.new(board[0].length) }

  queue = [Step.new(start_pos, direction)]
  visited = Set.new

  while step = queue.shift do
    pos = step.pos
    next if visited.include?(step)

    visited.add step
    energized[pos[0]][pos[1]] = true

    nss = next_steps(step, board)
    nss.each do |ns|
      queue.push(ns)
    end
  end

  energized.reduce(0) do |sum,line|
    sum + line.count { _1 }
  end
end

p task1: calc_energy([0,0], RIGHT, BOARD)

max_energy = 0
BOARD.each_with_index do |line, i|
  line.each_with_index do |e, j|
    if i == 0
      e = calc_energy([i,j], DOWN, BOARD)
      if e > max_energy
        max_energy = e
      end
    end

    if j == 0
      e = calc_energy([i,j], RIGHT, BOARD)
      if e > max_energy
        max_energy = e
      end
    end

    if i == BOARD.length - 1
      e = calc_energy([i,j], UP, BOARD)
      if e > max_energy
        max_energy = e
      end
    end

    if j == BOARD[0].length - 1
      e = calc_energy([i,j], LEFT, BOARD)
      if e > max_energy
        max_energy = e
      end
    end
  end
end

p task2: max_energy
