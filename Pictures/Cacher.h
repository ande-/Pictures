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
- (UIImage *)getImageForPhotoId:(NSString *)uniqueId;
- (void)cacheImage:(UIImage *)image forPhotoId:(NSString *)uniqueId;



@end
