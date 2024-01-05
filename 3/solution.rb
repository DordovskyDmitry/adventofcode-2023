lines = File.readlines('input.txt', chomp: true)

lines_numbers = []
lines_stars = []

lines.each_with_index.map do |l, i|
    lines_numbers[i] = []
    l.scan(/(\d+)/) do |n|
        number = n[0].to_i
        interval = $~.offset(0)
        if interval[0] > 0
          interval[0] -= 1
        end
        lines_numbers[i] << [number, interval[0]..interval[1]]
    end

    lines_stars[i] = []
    l.scan(/(\*)/) do |n|
        lines_stars[i] << $~.offset(0)[0]
    end
end


nums_to_sum = []

lines_stars.each_with_index do |line_stars, i|
    line_stars.each do |star|
        neighbors = []
        if i > 0
            if lines_numbers[i-1].any?
                neighbors += lines_numbers[i-1].select { |n| n[1].include?(star) }
            end
        end

        if lines_numbers[i].any?
            neighbors += lines_numbers[i].select { |n| n[1].include?(star) }
        end

        if i < lines_stars.length - 1
            if lines_numbers[i+1].any?
                neighbors += lines_numbers[i+1].select { |n| n[1].include?(star) }
            end
        end

        if neighbors.count == 2
            nums_to_sum << neighbors[0][0] * neighbors[1][0]
        end
    end
end

p nums_to_sum.reduce(:+)