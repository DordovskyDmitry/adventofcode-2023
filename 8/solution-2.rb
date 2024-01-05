lines = File.readlines('input.txt', chomp: true)

instructions = lines[0].split('')

map = lines[2..].reduce({}) do |agg, line|
  line.match(/([A-Z0-9]+) = \(([A-Z0-9]+)\, ([A-Z0-9]+)\)/)

  agg.merge($1 => { 'L' => $2, 'R' => $3})
end

starting_nodes = map.keys.filter { |x| x[2] == 'A' }

lengths = [0] * starting_nodes.length

starting_nodes.each_with_index do |starting_node, i|
  current_node = starting_node
  length = 0
  instructions.cycle.each do |step|
    current_node = map[current_node][step]
    length += 1
    if current_node[2] == 'Z'
      break
    end
  end
  lengths[i] = length
end

p lengths.reduce(instructions.length) { |agg, e| agg.lcm(e) }

# The code gets right result on the current input. But there is no proof on cycle length in it.
# It just happened that path length to the cycle is equal of cycle's length, so lcm could be used

