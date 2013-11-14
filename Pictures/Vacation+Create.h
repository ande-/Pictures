//
//  Vacation+Create.h
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "Vacation.h"

@interface Vacation (Create)

+(Vacation *)vacationWithTitle:(NSString *)title inManagedObectContext:(NSManagedObjectContext *)context;

@end
