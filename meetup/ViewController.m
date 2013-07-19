//
//  ViewController.m
//  meetup
//
//  Created by Chris League on 7/17/13.
//  Copyright (c) 2013 Chris League. All rights reserved.
//

#import "ViewController.h"
#import "Meetup.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.selectedMeetup = nil;
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    [self.locManager startUpdatingLocation];
    self.tableView.dataSource = self;
    self.mapView.delegate = self;
}

- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"Pin";
    if(annotation == mapView.userLocation) {
        return nil;
    }
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if(pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    }
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedMeetup = view.annotation;
    [self performSegueWithIdentifier:@"mapToWeb" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
    NSLog(@"%@", loc);
    self.meetups = [Meetup queryMeetupsNear:loc.coordinate];
    NSLog(@"%@", self.meetups);
    [self.tableView reloadData];
    for(Meetup *m in self.meetups) {
        [self.mapView addAnnotation:m];
    }
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(loc.coordinate, 10000, 10000);
    [self.mapView setRegion:region];
    self.spinner.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *dvc = segue.destinationViewController;
    if(self.selectedMeetup) {
        dvc.meetup = self.selectedMeetup;
        self.selectedMeetup = nil;
    } else {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        dvc.meetup = [self.meetups objectAtIndex:path.row];
    }
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
