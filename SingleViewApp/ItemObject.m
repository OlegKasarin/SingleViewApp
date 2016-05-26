//
//  ItemObject.m
//  SingleViewApp
//
//  Created by apple on 5/25/16.
//  Copyright © 2016 OlegKasarin. All rights reserved.
//

#import "ItemObject.h"

@implementation ItemObject

- (instancetype) initWithCity: (NSString*) city Code: (NSString*) code CityDesc: (NSString*) cityDesc Temp: (NSString*) temp WeatherDesc: (NSString*) weatherDesc {
    
    self = [super init];
    if (self) {
        _city = city;
        _code = code;
        _cityDescription = cityDesc;
        _temperature = temp;
        _weatherDescription = weatherDesc;
    }
    return self;
    
}

//- (NSString*) temperature {
//    return [NSString stringWithFormat:@"%@°", self.temperature];
//}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.city = [decoder decodeObjectForKey:@"city"];
    self.code = [decoder decodeObjectForKey:@"code"];
    self.cityDescription = [decoder decodeObjectForKey:@"cityDescription"];
    self.temperature = [decoder decodeObjectForKey:@"temperature"];
    self.weatherDescription = [decoder decodeObjectForKey:@"weatherDescription"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeObject:self.cityDescription forKey:@"cityDescription"];
    [encoder encodeObject:self.temperature forKey:@"temperature"];
    [encoder encodeObject:self.weatherDescription forKey:@"weatherDescription"];
}


@end
