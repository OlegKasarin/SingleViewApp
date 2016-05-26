//
//  HistoryManager.h
//  SingleViewApp
//
//  Created by apple on 5/25/16.
//  Copyright © 2016 OlegKasarin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemObject.h"

@interface HistoryManager : NSObject

@property (strong, nonatomic) NSMutableArray* itemObjects;

+ (HistoryManager*)sharedInstance;
- (void)saveObjects;

@end
