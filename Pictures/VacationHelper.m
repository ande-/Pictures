//
//  VacationHelper.m
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "VacationHelper.h"
#import "Vacation+Create.h"

static UIManagedDocument *vacationDoc;

@implementation VacationHelper

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:vacationName];

    if (!vacationDoc) {
        vacationDoc = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        if (vacationDoc.documentState == UIDocumentStateClosed) {
            [vacationDoc openWithCompletionHandler:^(BOOL success){
                completionBlock(vacationDoc);
            }];
        }
        else {
            completionBlock(vacationDoc);
        }
    }
    else {
        [vacationDoc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            completionBlock(vacationDoc);
        }];
        [Vacation vacationWithTitle:vacationName inManagedObectContext:vacationDoc.managedObjectContext];

    }
}

+ (NSManagedObjectContext *)managedObjectContext
{
    return vacationDoc.managedObjectContext;
}

@end
