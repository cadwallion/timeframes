require 'spec_helper'

describe TimeframeSeries do
  it "should take an array of timeframes" do
    timeframes = [
      Timeframe.new("2011-01-01 01:00", "2011-01-02 01:00"), 
      Timeframe.new("2011-02-02 02:00", "2011-02-02 02:22")
    ]
    
    t = TimeframeSeries.new(timeframes)
    t.timeframes.should == timeframes
  end
  
  it "concatenates two TimeframeSeries together" do
    timeframe1 = [
      Timeframe.new("2011-01-01 01:00", "2011-01-02 01:00"), 
      Timeframe.new("2011-02-02 02:00", "2011-02-02 02:22")
    ]
    
    timeframe2 = [
      Timeframe.new("2011-03-01 01:00", "2011-03-02 01:00"), 
      Timeframe.new("2011-03-02 02:00", "2011-03-02 02:22")
    ]
    t1 = TimeframeSeries.new(timeframe1)
    t2 = TimeframeSeries.new(timeframe2)
    t1 << t2
    t1.timeframes == (timeframe1 + timeframe2)
  end
  
  it "concatenates a Timeframe into the TimeframeSeries" do
    timeframes = [
      Timeframe.new("2011-01-01 01:00", "2011-01-02 01:00"), 
      Timeframe.new("2011-02-02 02:00", "2011-02-02 02:22")
    ]
    
    t = TimeframeSeries.new(timeframes)
    
    new_timeframe = Timeframe.new("2011-03-01 01:55", "2011-03-01 02:00")
    t << new_timeframe
    t.timeframes.should == (timeframes << new_timeframe)
  end
  
  it "outputs sequential days as a range" do
    timeframes = [
      Timeframe.new("2011-02-14 04:00", "2011-02-14 05:00"),
      Timeframe.new("2011-02-15 04:00", "2011-02-15 05:00"),
      Timeframe.new("2011-02-16 04:00", "2011-02-16 05:00"),
    ]
    series = TimeframeSeries.new(timeframes)
    
    series.series_in_words.should == "02/14-02/16 4:00am-5:00am"
  end
  
  it "outputs days with a common day of the week" do
    timeframes = [
      Timeframe.new("2011-02-14 04:00", "2011-02-14 05:00"),
      Timeframe.new("2011-02-21 04:00", "2011-02-21 05:00"),
      Timeframe.new("2011-02-28 04:00", "2011-02-28 05:00")
    ]
    series = TimeframeSeries.new(timeframes)
    
    series.series_in_words.should == "Mondays 04:00am-05:00am"
  end
  
  it "outputs days for every other weekday" do
    timeframes = [
      Timeframe.new("2011-02-14 04:00", "2011-02-14 05:00"),
      Timeframe.new("2011-02-28 04:00", "2011-02-28 05:00")
    ]
    
    series = TimeframeSeries.new(timeframes)
    series.series_in_words.should == "Every other Monday 04:00am-05:00am"
  end
end