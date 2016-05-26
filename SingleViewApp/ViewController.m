//
//  ViewController.m
//  SingleViewApp
//
//  Created by apple on 5/25/16.
//  Copyright © 2016 OlegKasarin. All rights reserved.
//

#import "ViewController.h"
#import "InfoTableViewCell.h"
#import "HistoryManager.h"
#import "ItemObject.h"
#import "WeatherManager.h"

@protocol WeatherManagerDelegate;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, WeatherManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) HistoryManager* historyManager;
@property (strong, nonatomic) ItemObject* selectedItem;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.historyManager = [HistoryManager sharedInstance];
    [[WeatherManager sharedInstance] setDelegate:self];
    
    NSLog(@"%lu", (unsigned long)[self.historyManager.itemObjects count]);
    
    if ([[self.historyManager itemObjects] count] == 0) {
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"JSONCountries" ofType:@"json"];
        NSString* myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
        if (!myJSON) {
            NSLog(@"File couldn't be read!");
        } else {
            [self getDataFromJSONString:myJSON];
            [[HistoryManager sharedInstance] saveObjects];
        }
    }
    
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getDataFromJSONString: (NSString*) string {
    
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray* JSONArray = [JSONDictionary objectForKey:@"countries"];
    
    for (id country in JSONArray) {
        
        ItemObject* item = [[ItemObject alloc] initWithCity:[country objectForKey:@"name"] Code:[country objectForKey:@"code"] CityDesc:[country objectForKey:@"description"] Temp:nil WeatherDesc:nil];
        
        [[[HistoryManager sharedInstance] itemObjects] addObject:item];
    }
    
    //
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[HistoryManager sharedInstance]itemObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoTableViewCell* cell = [[InfoTableViewCell alloc] init];
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCell"];

    
    ItemObject* item = [[[HistoryManager sharedInstance] itemObjects] objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item.city;
    cell.detailLabel.text = item.code;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemObject* item = [[[HistoryManager sharedInstance] itemObjects] objectAtIndex:indexPath.row];
    
    self.codeLabel.text = [NSString stringWithFormat:@"%@ <%@>", item.city, item.code];
    self.descriptionLabel.text = item.cityDescription;
    
    if (!item.temperature) {
        NSLog(@"No info about temp and weather...");

        self.selectedItem = item;
        
        //getWeatherForCity
        [[WeatherManager sharedInstance] getWeatherForObject:item];
        
        
    } else {
        NSLog(@"%@ %@", item.temperature, item.weatherDescription);
        self.cityLabel.text = [NSString stringWithFormat:@"%@ %@", item.temperature, item.weatherDescription];
    }

    //
}



#pragma mark - WeatherManagerDelegate

- (void) weatherHasSetForObject: (ItemObject*) object {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [[[HistoryManager sharedInstance] itemObjects] replaceObjectAtIndex:[[[HistoryManager sharedInstance] itemObjects] indexOfObject:object]
                                                                 withObject:object];
    
        if ([object isEqual:self.selectedItem]) {
        
            self.cityLabel.text = [NSString stringWithFormat:@"%@ %@", object.temperature, object.weatherDescription];
        
        } else {
            NSLog(@"Current object has changed");
        }
        
    });
    //
    [[HistoryManager sharedInstance] saveObjects];
}





@end
