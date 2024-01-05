MOD = 256
FACTOR = 17

def encode(e)
  e.each_byte.reduce(0) do |acc, c|
    ((acc + c) * FACTOR) % MOD
  end
end

input = File.read('input.txt')
elements = input.split(',')
p task1: elements.sum { |e| encode(e) }

boxes = Array.new(MOD) { [] }
elements.each do |e|
  if e.include?("=")
    code, focal = e.split("=")
    box = boxes[encode(code)]
    lens = box.detect { |elem| elem[0] == code }
    if lens
      lens[1] = focal
    else
      box << [code, focal]
    end
  else
    code = e[0...-1]
    box = boxes[encode(code)]
    to_delete = box.detect { |elem| elem[0] == code }
    box.delete(to_delete)
  end
end

sum = 0
boxes.each_with_index do |box, i|
  box.each_with_index do |e, j|
    sum += (i+1) * (j+1) * e[1].to_i
  end
end
p task2: sum

