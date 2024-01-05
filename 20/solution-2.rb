lines = File.readlines('input.txt', chomp: true)

types = {}
connections = {}
flip_flop_statuses = {}
last_impulses = {}

lines.each do |line|
  sender, receivers = line.split(' -> ')
  receivers = receivers.split(', ')
  if sender != 'broadcaster'
    type = sender[0]
    sender = sender[1...]
  end

  last_impulses = { sender => 'low' }

  connections[sender] = receivers
  types[sender] = type
  if type == '%' # flip flop
    flip_flop_statuses[sender] = 'off'
  elsif type == '&' # conjunction
  end
end

receiver_to_senders = {}
connections.each do |sender, receivers|
  receivers.each do |receiver|
    receiver_to_senders[receiver] ||= []
    receiver_to_senders[receiver] << sender
  end
end

button_pushes = 0
to_turn = 'rx'
goal_senders = receiver_to_senders[to_turn].select { |x| types[x] == '&' }
check_high_data = {}

loop do
  button_pushes += 1
  queue = [['broadcaster', 'low']]
  while to_process = queue.shift do
    entry, impulse = to_process
    last_impulses[entry] = impulse

    connections[entry].each do |receiver|
      if impulse == 'low' && receiver == to_turn
        p task2: button_pushes
        exit
      end

      if types[receiver] == '%' && impulse == 'low'
        if flip_flop_statuses[receiver] == 'on'
          flip_flop_statuses[receiver] = 'off'
          queue.push [receiver, 'low']
        else
          flip_flop_statuses[receiver] = 'on'
          queue.push [receiver, 'high']
        end
      end

      if types[receiver] == '&'
        if goal_senders.include?(receiver) && impulse == 'high'
          check_high_data[receiver] ||= {}
          check_high_data[receiver][entry] ||= button_pushes # assume cycles
          if check_high_data[receiver].size == receiver_to_senders[receiver].size && check_high_data.all? { |_, v| v }
            p task2: check_high_data[receiver].values.reduce { |acc, e| acc.lcm(e) }
            exit
          end
        end

        receiver_to_senders[receiver].map
        if receiver_to_senders[receiver].all? { |conn| last_impulses[conn] == 'high' }
          queue.push [receiver, 'low']
        else
          queue.push [receiver, 'high']
        end
      end
    end
  end
end
