Timeframes
====

Timeframes is a library to handle two points in time and easily parse and manipulate a series of timeframes.  It provides two new classes, Timeframe and TimeframeSeries.  Timeframes have a start and stop point in time and a series of common helpers to handle processing between those points in time.  TimeframeSeries allows for the creation of multiple Timeframe options to do data processing, including the ability to determine common date pattern matching.  

Install
----

		gem install timeframes
		
Usage
----
Usage of the Timeframe object:

		start = DateTime.new(2011, 2, 14, 4, 0)
		stop  = DateTime.new(2011, 2, 14, 5, 0)
		timeframe = Timeframes::Frame.new(start, stop)
		timeframe.duration(:seconds) # => 60
		timeframe.time # => 4:00am-5:00am
		
Usage of the TimeframeSeries object to explain the timeframe in words:

		timeframe1 = Timeframes::Frame.new(DateTime.new(2011, 02, 14, 4, 0), DateTime.new(2011, 02, 14, 5, 0))
		timeframe2 = Timeframes::Frame.new(DateTime.new(2011, 02, 21, 4, 0), DateTime.new(2011, 02, 21, 5, 0))		
		timeframe3 = Timeframes::Frame.new(DateTime.new(2011, 02, 28, 4, 0), DateTime.new(2011, 02, 28, 5, 0))
		series = Timeframes::Series.new([timeframe1, timeframe2, timeframe3])
		series.series_in_words # => Every Monday, 4:00am-5:00am
		
TODO
----

* Improve more complex date patterns
* Add Timeframe manipulation methods
* Documentation

Contributing
----

Please feel free to fork and submit a pull request for features or improvements you'd like to see in this lib.


Author
----

Created by Andrew Nordman - cadwallion@gmail.com - @cadwallion