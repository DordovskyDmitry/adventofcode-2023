
p(File.readlines('input.txt', chomp: true).reduce(0) do |sum, l|
    /Game (\d+): (.*)/.match(l)
    game_n = $1.to_i
    tours = $2

    red_max = tours.scan(/(\d+) red/).flatten.map(&:to_i).max
    green_max = tours.scan(/(\d+) green/).flatten.map(&:to_i).max
    blue_max = tours.scan(/(\d+) blue/).flatten.map(&:to_i).max

    sum + (red_max * green_max * blue_max)
end)
