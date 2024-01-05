lines = File.readlines('input.txt', chomp: true)

def hand_value(hand)
  values = hand.split('').group_by{|x| x}.transform_values { |v| v.count }
  if values['J']
    j_value = values.delete('J')

    if values.size > 0 # not JJJJJ case
      max_key, _ = values.max_by { |k, v| [v, CARD_SCORES[k] || k.to_i]}
      values[max_key] += j_value
    else
      return 7
    end
  end

  case values.size
  when 1
    7
  when 2
    values.values.sort == [1,4] ? 6 : 5
  when 3
    values.values.max == 3 ? 4 : 3
  when 4
    2
  when 5
    1
  end
end

CARD_SCORES = {
  'A' => 14,
  'K' => 13,
  'Q' => 12,
  'J' => 1,
  'T' => 10
}

def hand_to_card_scores(hand)
  hand.split('').map { |l| CARD_SCORES[l] || l.to_i }
end

score_map = lines.reduce({}) do |agg, line|
  hand, num = line.split(' ')
  agg.merge(hand => [num.to_i, [hand_value(hand), *hand_to_card_scores(hand)]])
end

sorted = (score_map.sort_by do |hand, (num, v)|
  v
end)


whole_score = sorted.each_with_index.reduce(0) do |sum, (e, i)|
  sum + (i+1) * e.last.first
end
p whole_score