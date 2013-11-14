//
//  Photo+Create.h
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "Photo.h"
#import "Vacation.h"
@interface Photo (Create)
+ (Photo *)photoWithPhoto:(NSDictionary *)photo inVacation:(Vacation *)vacation inManagedObectContext:(NSManagedObjectContext *)context;

@end
