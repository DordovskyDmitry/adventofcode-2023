lines = File.readlines('input.txt', chomp: true)
p(lines.reduce(0) do |sum,line|
  seq = line.split(' ').map(&:to_i)
  last = seq.last
  while !seq.all?(&:zero?) do
    seq = seq.each_cons(2).map{|x,y| y - x }
    last += seq.last
  end

  sum + last
end)