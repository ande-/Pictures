//
//  FlickrPhotoAnnotation.m
//  Pictures
//
//  Created by Andrea Houg on 10/5/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"

@implementation FlickrPhotoAnnotation

@synthesize photo = _photo;

+ (FlickrPhotoAnnotation *)annotationforPhoto:(NSDictionary *)photo
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

#pragma mark MKAnnotation delegate methods
- (NSString *)title
{
    return [self.photo objectForKey:@"title"];
}

- (NSString *)subtitle
{
    return [self.photo objectForKey:@"description._content"];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:@"latitude"] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:@"longitude"] doubleValue];
    return coordinate;

}

@end
