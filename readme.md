What is IAWeatherBugClient?
---------------------------

IAWeatherBugClient is an Objective-C wrapper class for WeatherBug's JSON API. IAWeatherBugClient requires at least iOS 5.0.

How do I use it?
----------------

1. Instantiate an instance with the -initWithAPIKey: method.
2. Call one of the three methods on IAWeatherBugClient. The results will be returned via a block along with an NSError object.

Note: The block passed into these methods is not guaranteed to be run on any particular thread. If you're working within UIKit, you are responsible for sending those messages on the main thread.

The future?
-----------

I created this class as part of development of an app and would love to see how this could be expanded. Feel free to do whatever you'd like with this code.