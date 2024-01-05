$cache = {}

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
      subs << new_row
    end
    break if row[i] == '#'
  end

  subs
end

def neighbors(row, num, others)
  sum = others.sum
  minimal_fill = sum + others.size
  to = row.size - minimal_fill - num

  substitutes(row, num, to)
end

def check(row)
  row.nil? || row.none? {|x| x == '#'}
end

def possibilities(row, nums)
  if nums.empty?
    return check(row) ? 1 : 0
  end

  if $cache[[row, nums]]
    return $cache[[row, nums]]
  end

  num = nums[0]
  other = nums[1...]
  $cache[[row, nums]] = neighbors(row, num, other).sum do |neighbor|
    possibilities(neighbor, other)
  end
end

REPEATS = 5

lines = File.readlines('input.txt', chomp: true)

p(lines.each_with_index.sum do |line, i|
  row, nums = line.split(' ')
  nums = nums.split(',').map(&:to_i) * REPEATS
  row = ([row] * REPEATS).join('?').gsub(/\.+/, '.').split('')

  if row[0] == '.'
    row = row[1...]
  end

  if row[-1] == '.'
    row = row[0..-2]
  end

  possibilities(row, nums)
end)
