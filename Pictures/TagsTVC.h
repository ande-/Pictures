//
//  TagsTVC.h
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Vacation.h"

@interface TagsTVC : CoreDataTableViewController

@property (strong, nonatomic) Vacation *vacation;

@end
