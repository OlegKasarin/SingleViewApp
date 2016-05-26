//
//  HistoryManager.m
//  SingleViewApp
//
//  Created by apple on 5/25/16.
//  Copyright © 2016 OlegKasarin. All rights reserved.
//

#import "HistoryManager.h"

@implementation HistoryManager


+ (HistoryManager*)sharedInstance {
    
    static HistoryManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HistoryManager alloc] init];
        sharedInstance.itemObjects = [sharedInstance objectFromDisk];
        //sharedInstance.itemObjects = [NSMutableArray new];
    });
    
    return sharedInstance;
}


- (NSMutableArray*)objectFromDisk {
    
    NSString* directoryPath = [self directoryPath];
    
    NSArray* fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
    
    NSMutableArray* objectsArray = [NSMutableArray array];
    
    for (NSString* fileName in fileList) {
        
        NSData* data = [NSData dataWithContentsOfFile:[[self directoryPath] stringByAppendingPathComponent:fileName]];
        objectsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    }
    
    return objectsArray;
}


- (void)saveObjects {
    
    
    NSString* fileName = @"itemObjects"; //unique id
    
    NSString* filePath = [[self directoryPath] stringByAppendingPathComponent:fileName]; //full address
    
    [NSKeyedArchiver archiveRootObject:self.itemObjects toFile:filePath];
    
}


- (NSString*)directoryPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = [paths objectAtIndex:0];
    //documentsDirectoryPath = [documentsDirectoryPath stringByAppendingPathComponent:@"objects"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return documentsDirectoryPath;
}

@end
