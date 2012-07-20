//
//  WRWeatherBugClient.h
//  Weather
//
//  Created by Mark Adams on 7/7/12.
//  BSD License
//

#import <Foundation/Foundation.h>

typedef void (^WRWeatherBugClientCompletionBlock)(id results, NSError *error);

@interface IAWeatherBugClient : NSObject

- (id)initWithAPIKey:(NSString *)key;

- (void)currentConditionsForLatitude:(double)latitude longitude:(double)longitude withCompletionBlock:(WRWeatherBugClientCompletionBlock)block;
- (void)hourlyForecastForLatitude:(double)latitude longitude:(double)longitude withCompletionBlock:(WRWeatherBugClientCompletionBlock)block;
- (void)dailyForecastForLatitude:(double)latitude longitude:(double)longitude numberOfDays:(NSUInteger)numberOfDays withCompletionBlock:(WRWeatherBugClientCompletionBlock)block;

@end
