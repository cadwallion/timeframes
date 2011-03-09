module Timeframes
  class Frame
    attr_reader :start, :stop
    class InvalidDateError < Exception ; end
  
    include Enumerable
  
    def initialize(start, stop)
      @start = start.is_a?(DateTime) ? start : DateTime.parse(start)
      @stop = stop.is_a?(DateTime) ? stop : DateTime.parse(stop)
      if @stop < @start
        raise InvalidDateError, "Stop cannot be before start"
      end
    end
  
    def to_s
      if @stop - @start < 24.hours
        @start.strftime("%m/%d/%Y %I:%M:%S %p") + " - " + @stop.strftime("%I:%M:%S %p")
      else
        @start.strftime("%m/%d/%Y %I:%M:%S %p") + " - " + @stop.strftime("%m/%d/%Y %I:%M:%S %p")
      end
    end
  
    def ==(other)
      if other.respond_to?(:start) && other.respond_to?(:stop)
        if other.start == @start && other.stop == @stop
          true
        else
          false
        end
      else
        raise NoMethodError
      end
    end
  
    def <=>(other)
      if other.respond_to?(:start) && other.respond_to?(:stop)
        if @start.to_i < other.start.to_i
          -1
        elsif self == other
          0
        else
          1
        end
      else
        raise NoMethodError
      end
    end
  
    def duration
      @stop.to_i - @start.to_i
    end
  end
end