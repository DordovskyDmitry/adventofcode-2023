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
  sum = 0

  (1..(times / 2 - 1)).each do |i|
    x = 0
    weight_board[(times / 2) * side..(times / 2 + 1) * side - 1].each do |line|
      line[i * side..(i + 1) * side - 1].each do |e|
        if e.is_a?(Numeric) && (steps - e).even? && e <= steps
          x += 1
        end
      end

    end
    sum += x
  end

  partial = 0
  weight_board[(times/2)*side..(times/2+1)*side-1].each do |line|
    line[0..side-1].each do |e|
      if e.is_a?(Numeric) && (steps - e).even? && e <= steps
        partial += 1
      end
    end
  end
  p partial: partial
  p whole: sum

  sum + partial
end

def partial_count_second(weight_board, side, steps, times)
  sum = 0
  weight_board[(times/2 - 1)*side..(times/2)*side-1].each do |line|
    line[0..side-1].each do |e|
      if e.is_a?(Numeric) && (steps - e).even? && e <= steps
        sum += 1
      end
    end
  end
  sum
end

def partial_count_first(weight_board, side, steps, times)
  sum = 0
  weight_board[(times/2 - 1)*side..(times/2)*side-1].each do |line|
    line[side..2*side-1].each do |e|
      if e.is_a?(Numeric) && (steps - e).even? && e <= steps
        sum += 1
      end
    end
  end
  sum
end

def north_west(weight_board, side, steps, times)
  sum = 0
  weight_board[0..times/2*side-1].each do |line|
    line[0..times/2*side-1].each do |e|
      if e.is_a?(Numeric) && (steps - e).even? && e <= steps
        sum += 1
      end
    end
  end
  sum
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
  times =  (steps / 11) * 2 + 1
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

# [6, 10, 50, 100, 500, 1000].each do |n|
#   p n => task('test.txt', n)
# end
(100..111).each do |n|
  p '-----'
  p n => task('test.txt', n)
end
