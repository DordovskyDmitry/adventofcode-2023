
STRING_TO_NUMBER = {
    'one' => 'o1e',
    'two' => 't2o',
    'three' => 't3e',
    'four' => 'f4r',
    'five' => 'f5e',
    'six' => 's6x',
    'seven' => 's7n',
    'eight' => 'e8t',
    'nine' => 'n9e',
    'zero' => 'z0o'
}

# STRING_TO_NUMBER = [ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"].each_with_index.reduce({}) do |agg, (e, i)|
#   agg.merge(e => "#{e[0]}#{i}#{e[-1]}")
# end


p(File.readlines('input.txt', chomp: true).reduce(0) do |sum, l|
    STRING_TO_NUMBER.each { |str, num| l.gsub!(str, num) }

    first, *, last = l.scan(/\d/).map(&:to_i)
    last ||= first
    last ? sum + (10 * first + last) : sum
end)
