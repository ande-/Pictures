//
//  Tag+Create.m
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+(Tag *)tagForString:(NSString *)s inManagedObjectContext:(NSManagedObjectContext *)context
{
   Tag *retval = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
    retval.name = s;
    return retval;

}

@end
