SUBSTITUTION = Struct.new(:row, :nums)

$count = 0

def substitutes(row, num, to)
  subs = []

  (0..to).each do |i|
    l = i + num

    if row[l] != '#' && (i..l - 1).none? { |j| row[j] == '.' }
      new_row = if row[l] == '?'
                  row[l + 1...]
                else
                  row[l...]
                end
      $count += 1
      subs << new_row
    end
    break if row[i] == '#'
  end

  subs
end

def neighbors(substitution)
  num = substitution.nums.shift

  sum = substitution.nums.sum
  minimal_fill = sum + substitution.nums.size
  to = substitution.row.length - minimal_fill - num

  substitutes(substitution.row, num, to).map do |elem|
    SUBSTITUTION.new(elem, substitution.nums.dup)
  end
end

def check(row)
  row.nil? || row.none? {|x| x == '#'}
end

def possibilities(row, nums)
  count = 0

  queue = [SUBSTITUTION.new(row, nums.dup)]

  while substitution = queue.shift do
    nbs = neighbors(substitution)

    nbs.each do |neighbor|
      all_applied =  neighbor.nums.empty?

      if all_applied
        if check(neighbor.row)
          count += 1
        end
      else
        queue.unshift neighbor
      end
    end
  end
  count
end

REPEATS = 1

lines = File.readlines('input.txt', chomp: true)

all = lines.each_with_index.map do |line, i|
  row, nums = line.split(' ')
  row = ([row] * REPEATS).join('?').gsub(/\.+/, '.').split('')

  if row[0] == '.'
    row = row[1...]
  end

  if row[-1] == '.'
    row = row[0..-2]
  end

  nums = nums.split(',').map(&:to_i) * REPEATS

  poss = possibilities(row, nums)
  p i => poss
  poss
end

# pp all
p $count

p all.sum