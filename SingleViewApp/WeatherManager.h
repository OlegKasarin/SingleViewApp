//
//  WeatherManager.h
//  SingleViewApp
//
//  Created by apple on 5/26/16.
//  Copyright © 2016 OlegKasarin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemObject.h"

@protocol WeatherManagerDelegate;




@interface WeatherManager : NSObject

@property (strong, nonatomic) NSString* temperature;
@property (strong, nonatomic) NSString* weatherDescription;
@property (weak, nonatomic) id <WeatherManagerDelegate> delegate;

+ (instancetype)sharedInstance;
- (void) getWeatherForObject: (ItemObject*) object;

@end


@protocol WeatherManagerDelegate

- (void) weatherHasSetForObject: (ItemObject*) object;

@end