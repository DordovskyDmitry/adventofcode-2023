lines = File.readlines('input.txt', chomp: true)

instructions = lines[0]

map = lines[2..].reduce({}) do |agg, line|
  line.match(/([A-Z]+) = \(([A-Z]+)\, ([A-Z]+)\)/)

  agg.merge($1 => { 'L' => $2, 'R' => $3})
end

length = 0

current_pos = 'AAA'

instructions.split('').cycle.each do |step|
  current_pos = map[current_pos][step]
  length +=1
  if current_pos == 'ZZZ'
    p length
    exit
  end
end
