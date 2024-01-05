def source_to_dest_map(file_name)
  map_lines = File.readlines(file_name, chomp: true)
  map = {}
  map_lines.each do |line|
    dest_start, source_start, length = line.split(' ').map(&:to_i)
    map[source_start..source_start + length - 1] = dest_start - source_start
  end
  map
end

def next_ranges(ranges, map)
  range_map = ranges.reduce({}) do |agg, range|
    agg.merge(range => 0)
  end

  map.each do |r, modifier|
    new_range_map = range_map.dup
    range_map.each do |range, d|
      if r.cover?(range)
        new_range_map[range] = modifier
      elsif range.cover?(r)
        if d != 0
          fail "something is not correct"
        end
        new_range_map.delete(range)
        new_range_map[range.begin..r.begin - 1] = 0
        new_range_map[r] = modifier
        new_range_map[r.end + 1..range.end] = 0
      elsif range.include?(r.begin)
        if d != 0
          fail "something is not correct"
        end
        new_range_map.delete(range)
        new_range_map[range.begin..r.begin - 1] = 0
        new_range_map[r.begin + 1..range.end] = modifier
      elsif range.include?(r.end)
        if d != 0
          fail "something is not correct"
        end
        new_range_map.delete(range)
        new_range_map[range.begin..r.end] = modifier
        new_range_map[r.end + 1..range.end] = 0
      end
    end
    range_map = new_range_map
  end

  range_map.reduce([]) do |agg, (r, d)|
    agg << (r.begin + d..r.end + d)
  end
end

lines = File.readlines('seeds.txt')
seed_numbers = lines[0].split(' ').map(&:to_i)
seeds = seed_numbers.each_slice(2).to_a.map { |f, l| (f..f + l - 1) }
seeds_to_soil = source_to_dest_map('seeds-to-soil.txt')
soil_to_fertilizer = source_to_dest_map('soil-to-fertilizer.txt')
fertilizer_to_water = source_to_dest_map('fertilizer-to-water.txt')
water_to_light = source_to_dest_map('water-to-light.txt')
light_to_temperature = source_to_dest_map('light-to-temperature.txt')
temperature_to_humidity = source_to_dest_map('temperature-to-humidity.txt')
humidity_to_location = source_to_dest_map('humidity-to-location.txt')

soil = next_ranges(seeds, seeds_to_soil)
fert = next_ranges(soil, soil_to_fertilizer)
water = next_ranges(fert, fertilizer_to_water)
light = next_ranges(water, water_to_light)
temp = next_ranges(light, light_to_temperature)
hum = next_ranges(temp, temperature_to_humidity)
loc = next_ranges(hum, humidity_to_location)
p loc.min_by(&:begin).begin - 1



