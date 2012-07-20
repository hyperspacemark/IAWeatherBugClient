//
//  WRWeatherBugClient.m
//  Weather
//
//  Created by Mark Adams on 7/7/12.
//  BSD License
//

#import "IAWeatherBugClient.h"

@interface IAWeatherBugClient ()

@property (nonatomic) NSOperationQueue *operationQueue;
@property (copy, nonatomic) NSString *APIKey;

@end

#pragma mark -

static NSString *const kWRWeatherBugBaseURLString = @"http://i.wxbug.net/REST/Direct/";
static NSString *const kWRWeatherBugObservations = @"GetObs.ashx?ic=1";
static NSString *const kWRWeatherBugDailyForecasts = @"GetForecast.ashx?&ht=d&ht=t&c=US&l=en&ih=0";
static NSString *const kWRWeatherBugHourlyForecasts = @"GetForecastHourly.ashx?ht=d&ht=fl";

@implementation IAWeatherBugClient

- (id)initWithAPIKey:(NSString *)key
{
    self = [super init];
    
    if (!self)
        return nil;
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _APIKey = [key copy];
    
    return self;
}

- (void)currentConditionsForLatitude:(double)latitude longitude:(double)longitude withCompletionBlock:(WRWeatherBugClientCompletionBlock)block
{
    if (!block)
        return;
    
    NSString *endpoint = [kWRWeatherBugObservations stringByAppendingFormat:@"&la=%f&lo=%f", latitude, longitude];
    
    [self requestValueForEndpoint:endpoint completionBlock:^(id result, NSError *error) {
        
        if (!result)
        {
            block(nil, error);
            return;
        }
        
        if (![result isKindOfClass:[NSDictionary class]])
            return;
        
        block(result, nil);
    }];
}

- (void)hourlyForecastForLatitude:(double)latitude longitude:(double)longitude withCompletionBlock:(WRWeatherBugClientCompletionBlock)block
{
    if (!block)
        return;
    
    NSString *endpoint = [kWRWeatherBugHourlyForecasts stringByAppendingFormat:@"&la=%f&lo=%f", latitude, longitude];
    
    [self requestValueForEndpoint:endpoint completionBlock:^(id result, NSError *error) {
        
        if (!result)
        {
            block(nil, error);
            return;
        }
        
        block(result, nil);
    }];
}

- (void)dailyForecastForLatitude:(double)latitude longitude:(double)longitude numberOfDays:(NSUInteger)numberOfDays withCompletionBlock:(WRWeatherBugClientCompletionBlock)block
{
    if (!block)
        return;
    
    NSString *endpoint = [kWRWeatherBugDailyForecasts stringByAppendingFormat:@"&nf=%i&la=%f&lo=%f", numberOfDays, latitude, longitude];
    
    [self requestValueForEndpoint:endpoint completionBlock:^(id result, NSError *error) {
        
        if (!result)
        {
            block(nil, error);
            return;
        }
        
        block(result, nil);
    }];
}

- (void)requestValueForEndpoint:(NSString *)endPoint completionBlock:(WRWeatherBugClientCompletionBlock)block
{
    if (!block)
        return;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&api_key=%@", kWRWeatherBugBaseURLString, endPoint, self.APIKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *requestError) {
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        id result = nil;
        NSError *JSONError = nil;
        
        switch (statusCode)
        {
            case 200:
                result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                break;
                
            case 404:
                // Handle this as necessary
                break;
                
            default:
                break;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block(result, requestError ?: JSONError);
        }];
    }];
}

@end