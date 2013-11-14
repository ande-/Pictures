//
//  VacationItem.h
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vacation.h"
#import "CoreDataTableViewController.h"

@interface VacationItem : CoreDataTableViewController

@property (strong, nonatomic) Vacation *vacation;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *tag;

@end

