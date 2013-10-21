//
//  Cacher.h
//  Pictures
//
//  Created by Andrea Houg on 10/16/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cacher : NSObject

+ (id)sharedInstance;
- (void)saveToUserDefaults:(NSDictionary *)photo;
- (void)cacheImage:(UIImage *)image forPhoto:(NSDictionary *)photo;
- (UIImage *)getImageForPhoto:(NSDictionary *)photo;

@end
