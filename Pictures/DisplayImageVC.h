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

@interface DisplayImageVC : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSDictionary *photo;
@property (strong, nonatomic) UIImage *image;

@end
