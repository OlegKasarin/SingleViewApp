//
//  WeatherManager.m
//  SingleViewApp
//
//  Created by apple on 5/26/16.
//  Copyright © 2016 OlegKasarin. All rights reserved.
//

#import "WeatherManager.h"


@implementation WeatherManager

+ (instancetype)sharedInstance
{
    static WeatherManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[WeatherManager alloc] init];
    });
    return sharedInstance;
}

- (void) getWeatherForObject: (ItemObject*) object {

    NSString* urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&appid=eba47effea88b18d5b67eae531209447", object.city];
    
    void (^block) (void) = ^{
    
        NSURL* url = [NSURL URLWithString:urlString];
        
        NSURLSession* session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            [self formDataFromDictionary: [self parsingJSONFromDataToDictionary:data]]; //forming properties from JSON data
            
            NSLog(@"Temperature: %@, Weather: %@", self.temperature, self.weatherDescription);
            
            object.temperature = self.temperature;
            object.weatherDescription = self.weatherDescription;
            
            [self.delegate weatherHasSetForObject:object];
        }];
        
        [task resume];
        
    };
    
    block();
}


#pragma mark - gettingWeatherMethods

-(NSDictionary*)parsingJSONFromDataToDictionary: (NSData*) responseData {
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    return jsonDict;
}

-(void) formDataFromDictionary: (NSDictionary*) dictionary {
    
    double temp = [[[dictionary objectForKey:@"main"] objectForKey:@"temp"] doubleValue] - 273.15f;
    self.temperature = [NSString stringWithFormat:@"%.f°", temp];
    
    self.weatherDescription = [NSString stringWithFormat:@"%@", [[[dictionary objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"]];
    
}
@end
