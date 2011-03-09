require 'spec_helper'

describe Timeframes::Series do
  it "should take an array of timeframes" do
    timeframes = [
      Timeframes::Frame.new("2011-01-01 01:00", "2011-01-02 01:00"), 
      Timeframes::Frame.new("2011-02-02 02:00", "2011-02-02 02:22")
    ]
    
    t = Timeframes::Series.new(timeframes)
    t.timeframes.should == timeframes
  end
  
  it "concatenates two TimeframeSeries together" do
    timeframe1 = [
      Timeframes::Frame.new("2011-01-01 01:00", "2011-01-02 01:00"), 
      Timeframes::Frame.new("2011-02-02 02:00", "2011-02-02 02:22")
    ]
    
    timeframe2 = [
      Timeframes::Frame.new("2011-03-01 01:00", "2011-03-02 01:00"), 
      Timeframes::Frame.new("2011-03-02 02:00", "2011-03-02 02:22")
    ]
    t1 = Timeframes::Series.new(timeframe1)
    t2 = Timeframes::Series.new(timeframe2)
    t1 << t2
    t1.timeframes == (timeframe1 + timeframe2)
  end
  
  it "concatenates a Timeframe into the TimeframeSeries" do
    timeframes = [
      Timeframes::Frame.new("2011-01-01 01:00", "2011-01-02 01:00"), 
      Timeframes::Frame.new("2011-02-02 02:00", "2011-02-02 02:22")
    ]
    
    t = Timeframes::Series.new(timeframes)
    
    new_timeframe = Timeframes::Frame.new("2011-03-01 01:55", "2011-03-01 02:00")
    t << new_timeframe
    t.timeframes.should == (timeframes << new_timeframe)
  end
  
  it "outputs sequential days as a range" do
    timeframes = [
      Timeframes::Frame.new("2011-02-14 04:00", "2011-02-14 05:00"),
      Timeframes::Frame.new("2011-02-15 04:00", "2011-02-15 05:00"),
      Timeframes::Frame.new("2011-02-16 04:00", "2011-02-16 05:00"),
    ]
    series = Timeframes::Series.new(timeframes)
    
    series.series_in_words.should == "02/14-02/16 4:00am-5:00am"
  end
  
  it "outputs days with a common day of the week" do
    timeframes = [
      Timeframes::Frame.new("2011-02-14 04:00", "2011-02-14 05:00"),
      Timeframes::Frame.new("2011-02-21 04:00", "2011-02-21 05:00"),
      Timeframes::Frame.new("2011-02-28 04:00", "2011-02-28 05:00")
    ]
    series = Timeframes::Series.new(timeframes)
    
    series.series_in_words.should == "Mondays 04:00am-05:00am"
  end
  
  it "outputs days for every other weekday" do
    timeframes = [
      Timeframes::Frame.new("2011-02-14 04:00", "2011-02-14 05:00"),
      Timeframes::Frame.new("2011-02-28 04:00", "2011-02-28 05:00")
    ]
    
    series = Timeframes::Series.new(timeframes)
    series.series_in_words.should == "Every other Monday 04:00am-05:00am"
  end
end