//
//  ItemObject.h
//  SingleViewApp
//
//  Created by apple on 5/25/16.
//  Copyright © 2016 OlegKasarin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemObject : NSObject <NSCoding>

@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* code;
@property (strong, nonatomic) NSString* cityDescription;
@property (strong, nonatomic) NSString* temperature;
@property (strong, nonatomic) NSString* weatherDescription;

- (instancetype) initWithCity: (NSString*) city Code: (NSString*) code CityDesc: (NSString*) cityDesc Temp: (NSString*) temp WeatherDesc: (NSString*) weatherDesc;

@end
