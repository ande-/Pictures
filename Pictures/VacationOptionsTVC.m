//
//  VacationOptionsTVC.m
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "VacationOptionsTVC.h"
#import "Vacation.h"
#import "Photo.h"

@interface VacationOptionsTVC ()

@end

@implementation VacationOptionsTVC

@synthesize vacation = _vacation;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
        [segue.destinationViewController performSelector:@selector(setVacation:) withObject:self.vacation];
    }
}

@end
