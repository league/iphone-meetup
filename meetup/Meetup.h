//  Meetup.h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Meetup : NSObject<MKAnnotation>
@property NSString *eventName;
@property NSURL *eventUrl;
@property NSString *groupName;
@property NSString *venueName;
@property CLLocationCoordinate2D venueLocation;

+(id)meetupFromJsonData:(NSDictionary*)dict;
+(NSMutableArray*) queryMeetupsNear:(CLLocationCoordinate2D)coordinate;

-(NSString*) title;
-(NSString*) subtitle;
-(CLLocationCoordinate2D) coordinate;

@end