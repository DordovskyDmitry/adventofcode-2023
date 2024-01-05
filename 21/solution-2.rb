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

def show_board(board)
  board.each do |line|
    line.each do |e|
      print e || '.'
    end
    print("\n")
  end
  p '-------'
end

def show_weight_board(board)
  board.each do |line|
    line[0..60].each do |e|
      print(e ? sprintf("%3d", e) : ' __')
    end
    print("\n")
  end
  p '-------'
end

def neighbors(current_pos, board)
  [UP, RIGHT, DOWN, LEFT].map do |dir|
    DIRECTIONS[dir].(current_pos[0], current_pos[1])
  end.filter do |(i, j)|
    i >= 0 && j >= 0 &&
      i < board.length && j < board[0].length &&
      board[i][j] != '#'
  end
end

def build_board(file, m)
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
  s = [board.length * (m / 2) + s[0], board[0].length * (m / 2) + s[1]]

  new_board = Array.new(board.length * m) { Array.new(board[0].length * m) }
  new_board.each_with_index do |line, i|
    line.each_with_index do |_, j|
      new_board[i][j] = board[i % board.length][j % board[0].length]
    end
  end
  [new_board, s]
end

def west(weight_board, side, steps, times)
  min_i = times / 2 * side
  max_i = min_i + side - 1
  min_target_j = (times / 2 - 3) * side
  max_target_j = min_target_j + side - 1

  from = weight_board[min_i][max_target_j]
  n = (steps - from) / side

  partial_limit = steps - n * side # compare with shifted 2 square
  partial_coverage = 0
  weight_board[min_i..max_i].each do |line|
    line[min_target_j..max_target_j].each do |e|
      next unless e.is_a? Numeric

      if e <= partial_limit && ((n.odd? && (steps-e).odd?) || (n.even? && (steps-e).even?))
        partial_coverage += 1
      end
    end
  end

  p partial: partial_coverage

  pre_partial_limit = steps - (n-1) * side # compare with shifted 2 square
  pre_partial_coverage = 0
  weight_board[min_i..max_i].each do |line|
    line[min_target_j..max_target_j].each do |e|
      next unless e.is_a? Numeric

      if e <= pre_partial_limit && (((n-1).odd? && (steps-e).odd?) || ((n-1).even? && (steps-e).even?))
        pre_partial_coverage += 1
      end
    end
  end

  p pre_partial: pre_partial_coverage

  odd = 0
  even = 0
  weight_board[min_i..max_i].each do |line|
    line[min_target_j..max_target_j].each do |e| # because shift 2 squares so they are equal
      if e.is_a? Numeric
        e.odd? ? odd+=1 : even+=1
      end
    end
  end

  if n.odd?
    like_first = (n+1)/2 # first from the center
    like_second = n/2 + 1 # second from the center
  else
    like_first = n/2 + 1
    like_second = n/2
  end

  whole_coverage = if steps.odd?
    odd * like_first + even * like_second
  else
    even * like_first + odd * like_second
  end

  p whole: whole_coverage

  whole_coverage + partial_coverage + pre_partial_coverage
end

def north_west(weight_board, side, steps, times)
  min_coord = (times / 2 - 1) * side
  max_coord = (times / 2 - 1) * side + side - 1
  from = weight_board[min_coord][max_coord]

  n = (steps - from) / side
  even = 0
  odd = 0
  weight_board[min_coord..max_coord].each do |line|
    line[min_coord..max_coord].each do |e|
      if e.is_a? Numeric
        e.odd? ? odd+=1 : even+=1
      end
    end
  end

  partial_limit_first = steps - n * side
  partial_limit_second = steps - (n+1) * side

  partial_count_first = 0
  partial_count_second = 0
  weight_board[min_coord..max_coord].each do |line|
    line[min_coord..max_coord].each do |e|
      next unless e.is_a? Numeric

      if e <= partial_limit_first && (partial_limit_first - e).even?
        partial_count_first += 1
      end
      if e <= partial_limit_second && (partial_limit_second - e).even?
        partial_count_second += 1
      end
    end
  end

  partial_coverage = partial_count_first * (n+1) + partial_count_second * (n+2)

  if n.odd?
    bigger = (n+1)*(n+1) / 4
    smaller = (n-1)*(n+1) / 4
  else
    bigger = n * (n+2) / 4
    smaller = n * n / 4
  end

  whole_coverage = if steps.odd? && n.odd?
                     even * smaller + odd * bigger
                   elsif steps.even? && n.even?
                     even * smaller + odd * bigger
                   elsif steps.even? && n.odd?
                     even * bigger + odd * smaller
                   elsif steps.odd? && n.even?
                     even * bigger + odd * smaller
                   end

  whole_coverage + partial_coverage
end

def center(weight_board, side, steps)
  even = 0
  odd = 0

  weight_board[side..2*side-1].each do |line|
    line[side..2*side-1].each do |e|
      if e.is_a? Numeric
        e.odd? ? odd+=1 : even+=1
      end
    end
  end

  steps.odd? ? odd : even
end

def transpose(field)
  new_field = Array.new(field[0].length)
  new_field.map! {|x| Array.new(field.length)}
  field.each_with_index do |line, i|
    line.each_with_index do |c, j|
      new_field[j][i] = c
    end
  end
  new_field
end

def task(file, steps)
  times = 7 # just big enough for the puzzle and odd to have symmetry
  board, s = build_board(file, times)

  weight_board = Array.new(board.length) { Array.new(board[0].length) }

  weight_board[s[0]][s[1]] = 0
  queue = [s]
  while point = queue.shift do
    neighbors(point, board).each do |n|
      unless weight_board[n[0]][n[1]]
        weight_board[n[0]][n[1]] = 1 + weight_board[point[0]][point[1]]
        queue.push n
      end
    end
  end

  # show_weight_board(weight_board)

  side = board.length / times
  nw = north_west(weight_board, side, steps, times)
  p nw: nw
  ne = north_west(weight_board.map(&:reverse), side, steps, times)
  p ne: ne
  sw = north_west(weight_board.reverse, side, steps, times)
  p sw: sw
  se = north_west(weight_board.reverse.map(&:reverse), side, steps, times)
  p se: se

  w = west(weight_board, side, steps, times)
  p w: w
  e = west(weight_board.map(&:reverse), side, steps, times)
  p e: e
  n = west(transpose(weight_board), side, steps, times)
  p n: n
  s = west(transpose(weight_board.reverse), side, steps, times)
  p s: s

  c = center(weight_board, side, steps)
  p c: c

  nw + ne + sw + se + w + n + e + s + c
end

p task('input.txt', 26501365)
