class TimeframeSeries
  attr_reader :timeframes
  
  def initialize(timeframes = [])
    @timeframes = timeframes
    @timeframes.sort!
  end
  
  def <<(other)
    if other.class == TimeframeSeries
      @timeframes << other.timeframes
    elsif other.class == Timeframe
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
  
  def check_common_weekday
    weekdays = @timeframes.map { |t| t.start.wday }
    scan_occurrences = weekdays.join("").scan(/#{weekdays.first}/).size
    if scan_occurrences > 1
      result_count = weekdays.join("").split(/(0\d{0,})\1{#{scan_occurrences-1},}/)
      if result_count.size  == 1
        weekday_patterns = result_count[0].split("")
        total_distances = {}
        scan_occurrences.times do |group|
          occurrence_distances = []
          (weekday_patterns.size).times do |day|
            total_distances[day] ||= []
            distance = @timeframes[day+(group+weekday_patterns.size)-1] - @timeframes[(day*group)-1]
            if @timeframes[(group*i)-1] + distance.days == @timeframes[(group*i)] # checking times, basically
              total_distances[day] << distance
            else
              return false
            end
          end
        end
        total_distances.each do |day, distances|
          if distances.uniq.size == 1
            total_distances[day] = distances
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
    @timeframes[1..(pattern.size-1)].each do |t|
      if !same_time?(t.start, @timeframes[0].start) && !same_time?(t.stop, @timeframes[0].stop)
        output = ""
        counter = 0
        pattern.each do |weekday|
          case weekday
          when 7
            qualifier = "Every %A"
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
          output << @timeframes[counter].strftime("#{qualifier}")
        end
      else
        default_output
      end
    end
    pattern.size
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
