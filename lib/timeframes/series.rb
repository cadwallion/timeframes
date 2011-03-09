module Timeframes
  class Series
    attr_reader :timeframes
  
    def initialize(timeframes = [])
      @timeframes = timeframes
      @timeframes.sort!
    end
  
    def <<(other)
      if other.class == Timeframes::Series
        @timeframes << other.timeframes
      elsif other.class == Timeframes::Frame
        @timeframes << other
      else
        raise ArgumentError
      end
    end
  
    def start
      @timeframes.first.start
    end
  
    def stop
      @timeframes.last.stop
    end
  
    def total_duration
      @timeframes.map(&:duration).sum
    end
  
    def series_in_words
      if check_sequential
        sequential_output
      elsif pattern = check_common_weekday
        common_weekday_output(pattern)
      elsif check_common_monthday
        # stub
      else
        default_output
      end
    end
  
    private
  
    # offset per group.  pattern_group 0 with dates_per_group 4 means comparing 0-3 to 4-7, 
    # then 4-7 to 8-11, through scan_occurrences times.
    # pattern_group * dates_per_group is the base index
    # (pattern_group + 1) * dates_per_group is the comparison index
    # Do not need to compare the last pattern to anything, so we decrement by 1.
    def check_common_weekday
      weekdays = @timeframes.map { |t| t.start.wday }
      scan = weekdays.join("").scan(/#{weekdays.first}/)
      scan_occurrences = scan.size
      if scan_occurrences > 1
        result_count = weekdays.join("").split(/(0\d{0,})\1{#{scan_occurrences-1},}/)
        if result_count.size  == 1
          weekday_patterns = result_count[0].split("")
          total_distances = {}
          dates_per_group = weekday_patterns.first.size
          (scan_occurrences - 1).times do |pattern_group| 
            dates_per_group.times do |date_within_group|
              base_index = (pattern_group * dates_per_group) + date_within_group
              comparison_index = ((pattern_group + 1) * dates_per_group) + date_within_group
              distance = @timeframes[comparison_index].start - @timeframes[base_index].start
              if (@timeframes[base_index].start + distance) == @timeframes[comparison_index].start
                total_distances[date_within_group] ||= []
                total_distances[date_within_group] << distance
              else
                return false
              end
            end
          end

          total_distances.each do |day, distances|
            if distances.uniq.size == 1
              total_distances[day] = distances.first
            else
              return false
            end
          end
          return total_distances
        else
          return false
        end
      else
        return false
      end
    end
  
    def check_common_monthday
      false
    end
  
    def check_sequential
      @timeframes.each_index do |k|
        unless @timeframes[k+1].nil?
          if same_day?(@timeframes[k+1].start, (@timeframes[k].start + 1.day)) && same_day?(@timeframes[k+1].stop, (@timeframes[k].stop + 1.day))
            next
          else
            return false
          end
        end
      end
      true
    end
  
    def sequential_output
      self.start.strftime("%m/%d") + "-" + self.stop.strftime("%m/%d") + " " + @timeframes.last.start.strftime("%l:%M%P").lstrip + "-" + @timeframes.last.stop.strftime("%l:%M%P").lstrip
    end
  
    def common_weekday_output(pattern)
      output = ""
      counter = 0
      number_of_weekdays = pattern.size
      pattern.each do |key, weekday|
        case weekday.to_i
        when 7
          qualifier = "%As"
        when 14
          qualifier = "Every other %A"
        else
          # 1st & 3rd Tuesday
        
          nth_days = @timeframes.map { |n| nth_dayname_of_month(n.start) }
          groups = (@timeframes.size / pattern.size)
          if groups > 2
            default_output
          else
            qualifier = "#{nth_days[0]} and #{nth_days[(groups*1)+1]} %A"
          end
        end
        output << @timeframes[counter].start.strftime("#{qualifier} %I:%M%P") << "-" << @timeframes[counter].stop.strftime("%I:%M%P")
        counter += 1
      end
      output
    end
  
    def default_output
      @timeframes.map(&:to_s).join(", ") # default (No pattern)
    end
  
    def same_time?(one, two)
      one.strftime("%I:%M%p") == two.strftime("%I:%M%p")
    end
  
    def same_day?(one, two)
      one.strftime("%m/%d/%Y") == two.strftime("%m/%d/%Y")
    end
  
    def nth_dayname_of_month(date)
      first_day_of_month = Date.new(date.year, date.month, 1)
      first_day_of_next_month = Date.new(date.year, date.next_month.month, 1)
      first_dayname_offset = (7 - (first_day_of_month.wday - date.wday).abs)
      if first_dayname_offset == 7
        first_dayname_offset = 0 
      end
      first_dayname_of_month = first_day_of_month + first_dayname_offset
      current_date = first_dayname_of_month 
      counter = 1
      while current_date < first_day_of_next_month
        if current_date == date
          break
        end
        current_date += 7
        counter += 1
      end
      return counter
    end
  end
end