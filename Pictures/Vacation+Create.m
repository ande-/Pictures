//
//  Vacation+Create.m
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "Vacation+Create.h"

@implementation Vacation (Create)

+(Vacation *)vacationWithTitle:(NSString *)title inManagedObectContext:(NSManagedObjectContext *)context
{
    Vacation *vacation = [NSEntityDescription insertNewObjectForEntityForName:@"Vacation" inManagedObjectContext:context];
    vacation.title = title;
    return vacation;
}

@end
