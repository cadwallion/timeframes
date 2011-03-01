date_strings = ["2011-02-01", "2011-03-01", "2011-04-01"]

require './lib/date_series'
range = DateSeries.new(date_strings)
puts range.find_pattern # => same_day_next_month