lines = File.readlines('input.txt', chomp: true)

/Time:(.*)/.match(lines[0])
time = $1.gsub(' ', '').to_i

/Distance:(.*)/.match(lines[1])
distance = $1.gsub(' ', '').to_i

# (time-hold)*hold - distance = 0

p Math.sqrt(time*time - 4*distance).floor # distance beetween parabola zeros
