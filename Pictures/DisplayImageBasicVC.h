//
//  DisplayImageBasicVC.h
//  Pictures
//
//  Created by Andrea Houg on 11/10/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayImageBasicVC : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *photoId;

@end
