//
//  DisplayImageVC.h
//  Pictures
//
//  Created by Andrea Houg on 9/16/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Cacher.h"
#import "DisplayImageBasicVC.h"

@interface DisplayImageVC : DisplayImageBasicVC
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSDictionary *photo;

@end
