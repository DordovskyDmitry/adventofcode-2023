lines = File.readlines('input.txt', chomp: true)
p(lines.reduce(0) do |sum,line|
  seq = line.split(' ').map(&:to_i)
  seqs = [seq]
  while !seq.all?(&:zero?) do
    seq = seq.each_cons(2).map{|x,y| y - x }
    seqs << seq
  end

  first = seqs.reverse.reduce(0) do |agg, seq|
    first = seq.first
    first - agg
  end

  sum + first
end)