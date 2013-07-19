// Meetup.m

#import "Meetup.h"

@implementation Meetup

+(id)meetupFromJsonData:(NSDictionary*)dict
{
    Meetup *m = [[self alloc] init];
    m.eventName = [dict objectForKey:@"name"];
    NSString *eventUrl = [dict objectForKey:@"event_url"];
    if('/' == [eventUrl characterAtIndex:[eventUrl length]-1]) {
        eventUrl = [NSString stringWithFormat:@"%@?set_mobile=on", eventUrl]; // Hack to use mobile format
    }
    m.eventUrl = [NSURL URLWithString:eventUrl];
    
    NSDictionary *group = [dict objectForKey:@"group"];
    m.groupName = [group objectForKey:@"name"];
    
    NSDictionary *venue = [dict objectForKey:@"venue"];
    m.venueName = [venue objectForKey:@"name"];
    
    NSNumber *lat = [venue objectForKey:@"lat"];
    NSNumber *lon = [venue objectForKey:@"lon"];
    m.venueLocation = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    
    return m;
}

+(NSMutableArray*) queryMeetupsNear:(CLLocationCoordinate2D)coordinate
{
    static const NSString *apiKey = @"YOUR-KEY-HERE";
    NSString *tmp = [NSString stringWithFormat:
                     @"https://api.meetup.com/2/open_events.json?lat=%lf&lon=%lf&time=,1w&key=%@",
                     coordinate.latitude,
                     coordinate.longitude,
                     apiKey];
    NSURL *url = [NSURL URLWithString:tmp];
    NSLog(@"fetching %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset"];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error) {
        NSLog(@"Request error: %@", error);
        return nil;
    }
    id json = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
    if(error) {
        NSLog(@"JSON error: %@", error);
        return nil;
    }
    NSMutableDictionary *jsonTmp = (NSMutableDictionary*) json;
    NSArray *meetups = (NSArray*) [jsonTmp objectForKey:@"results"];
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for(int i = 0; i < [meetups count]; i++) {
        Meetup *m = [Meetup meetupFromJsonData:[meetups objectAtIndex:i]];
        [a addObject:m];
    }
    return a;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.eventName, self.groupName];
}

-(NSString*) title
{
    return self.eventName;
}

-(NSString*) subtitle
{
    return self.groupName;
}

-(CLLocationCoordinate2D) coordinate
{
    return self.venueLocation;
}

@end
