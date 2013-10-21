//
//  PlaceAnnotation.h
//  Pictures
//
//  Created by Andrea Houg on 10/6/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceAnnotation : NSObject

@property (nonatomic, weak) NSDictionary *place;

+ (PlaceAnnotation *)annotationforPlace:(NSDictionary *)place;

@end
