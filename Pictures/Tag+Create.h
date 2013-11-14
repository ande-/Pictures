//
//  Tag+Create.h
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)
+(Tag *)tagForString:(NSString *)s inManagedObjectContext:(NSManagedObjectContext *)context;

@end
