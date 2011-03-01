require 'spec_helper'

describe Timeframe do
  it "should not allow a stop date before its start date" do
    expect { Timeframe.new("2011-01-02 01:00", "2011-01-01 01:00") }.to raise_exception(Timeframe::InvalidDateError, "Stop cannot be before start")
  end
  
  it "outputs duration between start and stop" do
    t = Timeframe.new("2011-01-01 01:00", "2011-01-01 02:00")
    t.duration.should == 3600
  end
  
  it "determines equality based on start and stop values" do
    t1 = Timeframe.new("2011-01-01 01:00", "2011-01-01 02:00")
    t2 = Timeframe.new("2011-01-01 01:00", "2011-01-01 02:00")
    t3 = Timeframe.new("2011-01-01 01:00", "2011-01-01 03:00")
    t4 = Timeframe.new("2011-01-01 03:00", "2011-01-01 04:00")
    
    t1.should == t2
    t1.should_not == t3
    t3.should_not == t4
  end
  
  it "sorts based on start value, then stop value" do
    t1 = Timeframe.new("2011-01-01 01:00", "2011-01-01 02:05")
    t2 = Timeframe.new("2011-01-01 01:00", "2011-01-01 02:00")
    t3 = Timeframe.new("2011-01-01 01:05", "2011-01-01 02:55")
    t4 = Timeframe.new("2011-01-01 02:00", "2011-01-01 02:30")
    [t4, t2, t3, t1].sort.should == [t2, t1, t3, t4]
  end
end