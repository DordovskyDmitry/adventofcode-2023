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

def move_north(board)
  board.each_with_index do |line, i|
    line.each_with_index do |c, j|
      if c == 'O'
        next
      end

      o_ind = (i..board.length - 1).take_while { |n| board[n][j] != '#'}.detect do |n|
        board[n][j] == 'O'
      end

      if o_ind
        board[i][j] = 'O'
        board[o_ind][j] = '.'
      end
    end
  end
end

def move_south(board)
  board.reverse!
  move_north(board)
  board.reverse!
end

def move_east(board)
  board.map! {|line| line.reverse }
  board = move_west(board)
  board.map! {|line| line.reverse }
end

def move_west(board)
  board = transpose(board)
  move_north(board)
  transpose(board)
end

def weight_north(board)
  weight = 0
  board.each_with_index do |line, i|
    line.each_with_index do |c, j|
      if c == 'O'
        weight += board.length - i
      end
    end
  end
  weight
end

lines = File.readlines('input.txt', chomp: true)
board = lines.map { |line| line.split('') }

COUNT = 1_000_000_000

boards = []

COUNT.times.map do |i|
  board = move_north(board)
  board = move_west(board)
  board = move_south(board)
  board = move_east(board)

  previous_index = (0..boards.length - 1).detect { |n| boards[n] == board}
  if previous_index
    cycle_length = i - previous_index
    num_in_cycle = (COUNT - (previous_index + 1)) % cycle_length

    p weight_north(boards[previous_index + num_in_cycle])

    break
  else
    boards << board.map(&:clone)
  end
end
