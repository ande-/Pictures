//
//  FlickrPhotoAnnotation.h
//  Pictures
//
//  Created by Andrea Houg on 10/5/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSDictionary *photo;

+ (FlickrPhotoAnnotation *)annotationforPhoto:(NSDictionary *)photo;

@end
