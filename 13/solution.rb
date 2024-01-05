def with_horizontal_reflection?(field, n)
  rl = [n, field.length - n - 2].min
  (0..rl).all? { |r| field[n - r] == field[n + 1 + r] }
end

def horizontal_reflection(field)
  ind = (0..field.length - 2).detect do |i|
    with_horizontal_reflection?(field, i)
  end

  ind ? ind + 1 : 0
end

def transpose(field)
  new_field = Array.new(field[0].length)
  new_field.map! {|x| Array.new(field.length)}
  field.each_with_index do |line, i|
    line.chars.each_with_index do |c, j|
      new_field[j][i] = c
    end
  end
  new_field.map(&:join)
end

def vertical_reflection(field)
  new_field = transpose(field)
  horizontal_reflection(new_field)
end

lines = File.readlines('input.txt', chomp: true)

fields = []
current_field = []
lines.each do |line|
  if line.empty?
    fields << current_field
    current_field = []
  else
    current_field << line
  end
end
fields << current_field

p(fields.reduce(0) do |acc, field|
  hr = horizontal_reflection(field)
  vr = vertical_reflection(field)

  acc + 100*hr + vr
end)