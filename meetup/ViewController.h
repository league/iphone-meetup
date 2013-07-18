//
//  ViewController.h
//  meetup
//
//  Created by Chris League on 7/17/13.
//  Copyright (c) 2013 Chris League. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate, UITableViewDataSource>
@property IBOutlet UISegmentedControl *viewSelector;
@property IBOutlet UITableView *tableView;
@property IBOutlet MKMapView *mapView;
@property NSMutableArray *meetups;
@property CLLocationManager *locManager;

-(IBAction)selectView:(id)sender;
@end
