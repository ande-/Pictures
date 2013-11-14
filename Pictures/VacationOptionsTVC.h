//
//  VacationOptionsTVC.h
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vacation.h"
#import "CoreDataTableViewController.h"

@interface VacationOptionsTVC : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) Vacation *vacation;


@end
