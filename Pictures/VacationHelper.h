//
//  VacationHelper.h
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completion_block_t)(UIManagedDocument *vacation);  //duh andrea!  it's returning the document

@interface VacationHelper : NSObject

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock;
+ (NSManagedObjectContext *)managedObjectContext;

@end
