require 'ostruct'

def build_bricks(file)
  lines = File.readlines(file, chomp: true)
  bricks = []
  lines.each do |line|
    from, to = line.split('~').map do |triple|
      triple.split(',').map(&:to_i)
    end
    brick = (0..2).map do |i|
      from[i]..to[i]
    end
    bricks << brick
  end
  bricks.sort_by { |_,_,z| z.min }
end

def put(brick, id, board, below, above)
  z_start = brick[2].min
  no_bricks_below = true

  while z_start > 1 && no_bricks_below
    brick[0].each do |x|
      brick[1].each do |y|
        below_id = board[x][y][z_start - 1]

        if below_id
          below[id] ||= Set.new
          above[below_id] ||= Set.new
          no_bricks_below = false
          below[id].add below_id
          above[below_id].add id
        end
      end
    end

    if no_bricks_below
      z_start -= 1
    end
  end

  z_range = z_start..z_start + brick[2].max - brick[2].min
  brick[0].each do |x|
    brick[1].each do |y|
      z_range.each do |z|
        board[x][y][z] = id
      end
    end
  end
end

def build_dependency_data(file)
  bricks = build_bricks(file)
  max_x = bricks.map { |b| b[0].max }.max
  max_y = bricks.map { |b| b[1].max }.max
  max_z = bricks.map { |b| b[2].max }.max
  board = Array.new(max_x + 1) { Array.new(max_y + 1) { Array.new(max_z + 1) } }

  below = {}
  above = {}
  bricks.each_with_index do |brick, id|
    put(brick, id, board, below, above)
  end

  OpenStruct.new(
    bricks: bricks,
    above: above,
    below: below,
    board: board)
end

def task1(file)
  dependencies = build_dependency_data(file)

  (0..dependencies.bricks.length - 1).reduce(0) do |c, id|
    aboves = dependencies.above[id]

    if aboves.nil? || aboves.all? { |dep_brick| (dependencies.below[dep_brick]).size > 1 }
      c + 1
    else
      c
    end
  end
end

def calc(to_delete, dependencies, fallen)
  return fallen.count if to_delete.size == 0

  fallen += to_delete
  fallen.uniq!

  layer_above = to_delete.reduce(Set.new) do |acc, brick_id|
    if dependencies.above[brick_id]
      acc + dependencies.above[brick_id]
    else
      acc
    end
  end

  next_to_delete = layer_above.filter do |brick_id|
    (dependencies.below[brick_id] - fallen).empty?
  end

  calc(next_to_delete, dependencies, fallen)
end

def task2(file)
  dependencies = build_dependency_data(file)

  targets = (0..dependencies.bricks.length - 1).filter do |id|
    aboves = dependencies.above[id]

    aboves && aboves.any? { |dep_brick| (dependencies.below[dep_brick]).size == 1 }
  end

  targets.reduce(0) do |sum, id|
    sum + calc([id], dependencies, [id]) - 1
  end
end

p task1: task1('input.txt')
p task2: task2('input.txt')
