lines = File.readlines('input.txt', chomp: true)

workflows = {}
inputs = []
switched = false
lines.map do |line|
  if line.empty?
    switched = true
    next
  end

  if switched
    input = line[1..-2].split(',').reduce({}) do |acc, eq|
      k, v = eq.split("=")
      acc.merge(k => v.to_i)
    end
    inputs << input

    # add inputs
  else
    line.match /(\w+)\{(.*)\,(.*)\}/
    wf_key = $1
    rules = $2.split(',')
    fallback = [nil, nil, nil, $3]
    converted_rules = rules.map do |rule|
      rule.match(/(\w+)([<>])(\d+):(\w+)/)
      [$1, $2, $3.to_i, $4]
    end

    workflows[wf_key] = converted_rules + [fallback]
  end
end

accepted = []

inputs.each do |input|
  current_filters = workflows["in"]
  loop do
    _, _, _, res = current_filters.detect do |var, cond, val, _|
      if var == nil
        true
      else
        current_val = input[var]

        if cond == '>'
          current_val > val
        else
          current_val < val
        end
      end
    end

    if res == 'A'
      accepted << input
      break
    elsif res == 'R'
      break
    else
      current_filters = workflows[res]
    end
  end
end

p task1: (accepted.sum do |h|
  h.values.sum
end)

############ Task 2 ############

def eval_pipeline(intervals, workflow, workflows)
  intervals = intervals.dup
  sum = 0

  workflow.each do |var, cond, val, outcome|
    if var.nil?
      remaining_intervals = intervals
    else
      interval = intervals[var]

      new_node_interval_value = cond == '>' ? (val+1..interval.max) : (interval.begin..val-1)
      remaining_intervals = intervals.merge(var => new_node_interval_value)
      intervals[var] = cond == '>' ? (interval.begin..val) : (val..interval.max)
    end

    if outcome != 'A' && outcome != 'R'
      sum += eval_pipeline(remaining_intervals, workflows[outcome], workflows)
    end

    if outcome == 'A'
      sum += %w[x m a s].reduce(1) do |acc, l|
        acc * (remaining_intervals[l] || []).count
      end
    end
  end

  sum
end

MAX = 4000
intervals = { 'x' => (1..MAX),
              'm' => (1..MAX),
              'a' => (1..MAX),
              's' => (1..MAX) }

p task2: eval_pipeline(intervals, workflows["in"], workflows)
