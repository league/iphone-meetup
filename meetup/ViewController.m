//
//  ViewController.m
//  meetup
//
//  Created by Chris League on 7/17/13.
//  Copyright (c) 2013 Chris League. All rights reserved.
//

#import "ViewController.h"
#import "Meetup.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    [self.locManager startUpdatingLocation];
    self.tableView.dataSource = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
    NSLog(@"%@", loc);
    self.meetups = [Meetup queryMeetupsNear:loc.coordinate];
    NSLog(@"%@", self.meetups);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.meetups count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Meetup *m = [self.meetups objectAtIndex:indexPath.row];
    cell.textLabel.text = m.eventName;
    cell.detailTextLabel.text = m.groupName;
    return cell;
}

-(IBAction)selectView:(id)sender
{
    int choice = [self.viewSelector selectedSegmentIndex];
    if(choice == 0) { // list
        self.tableView.hidden = NO;
        self.mapView.hidden = YES;
    }
    if(choice == 1) { // map
        self.mapView.hidden = NO;
        self.tableView.hidden = YES;
    }
}


@end
