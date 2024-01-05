def eliminate_edge(connections, node1, node2)
  connections[node1].delete(node2)
  connections[node2].delete(node1)
end

def find_subtree(test_connections3, k, visited = Set.new)
  visited.add(k)
  test_connections3[k].each do |conn|
    if !visited.include?(conn)
      find_subtree(test_connections3, conn, visited)
    end
  end
  visited
end

lines = File.readlines('input.txt', chomp: true)

connections = {}
lines.each do |line|
  components = line.split(' ')
  from = components[0][0...-1]
  connections[from] ||= []
  connections[from] += components[1...]
  components[1...].each do |component|
    connections[component] ||= []
    connections[component] += [from]
  end
end

# Run  to_graphviz_query.rb to generate graphiz query
# Run graphviz in neato mode (https://dreampuf.github.io/GraphvizOnline/)
# Delete a couple of last strings to fit limits
# There are obvious 3 edges to delete on the graph
# zlx - chr
# cpq - hlx
# hqp - spk
eliminate_edge(connections, "zlx", "chr")
eliminate_edge(connections, "cpq", "hlx")
eliminate_edge(connections, "hqp", "spk")

test_connections = connections.reduce({}) do |h, (k, v)| # deep clone
  h.merge(k => v.dup)
end

k, _ = test_connections.first
visited = find_subtree(test_connections, k)
if visited.count != connections.count
  size1 = visited.count
  visited.each do |v|
    test_connections.delete(v)
  end
  k, _ = test_connections.first
  visited = find_subtree(test_connections, k)

  if visited.count == test_connections.count
    size2 = visited.count
    p size2 * size1
  end
end
