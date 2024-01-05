lines = File.readlines('input.txt', chomp: true)

# 4.1
p(lines.reduce(0) do |agg, line|
  /Card\s+\d+: (.*) \| (.*)/.match(line)
  winning_list = $1.split(' ')
  numbers_you_have = $2.split(' ')
  your_wins = (winning_list & numbers_you_have).count
  agg + (2**(your_wins - 1)).to_i
end)

# 4.2
copies = { }

lines.each_with_index do |line, i|
  /Card\s+\d+: (.*) \| (.*)/.match(line)
  winning_list = $1.split(' ')
  numbers_you_have = $2.split(' ')
  your_wins = (winning_list & numbers_you_have).count

  copies[i] ||= 1

  your_wins.times do |j|
    copies[i+j+1] ||= 1
    copies[i+j+1] += copies[i]
  end
end

p copies.values.sum

