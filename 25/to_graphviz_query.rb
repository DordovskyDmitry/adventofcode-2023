lines = File.readlines('input.txt', chomp: true)

to_file = File.new('graph.txt', 'w')
to_file.write "graph graphname {\n"

lines.each do |line|
  components = line.split(' ')
  from = components[0][0...-1]
  components[1...].each do |component|
    to_file.write "#{from} -- #{component};\n"
  end
end
to_file.write "}\n"
to_file.close
