//
//  PlaceAnnotation.m
//  Pictures
//
//  Created by Andrea Houg on 10/6/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "PlaceAnnotation.h"
#import <MapKit/MapKit.h>
#import "FlickrFetcher.h"

@implementation PlaceAnnotation

@synthesize place = _place;

+ (PlaceAnnotation *)annotationforPlace:(NSDictionary *)place
{
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}

#pragma mark MKAnnotation delegate methods
- (NSString *)title
{
    return [self.place objectForKey:@"woe_name"];
}

- (NSString *)subtitle
{
    NSString *fullLocation = [self.place objectForKey:FLICKR_PLACE_NAME];
    NSString *city = [self.place objectForKey:@"woe_name"];
    return [fullLocation stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@, ", city] withString:@""];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
    
}
@end
