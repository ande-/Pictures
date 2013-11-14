//
//  DisplayImageBasicVC.m
//  Pictures
//
//  Created by Andrea Houg on 11/10/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "DisplayImageBasicVC.h"
#import "Cacher.h"

@interface DisplayImageBasicVC ()

@end

@implementation DisplayImageBasicVC

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize image = _image;
@synthesize photoId = _photoId;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.scrollView.zoomScale = 1;
    self.imageView.image = self.image;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize imageSize = self.imageView.image.size;
    CGSize frameSize = self.scrollView.bounds.size;
    BOOL isWide = imageSize.width >= imageSize.height;
    CGFloat otherValue = !isWide ? (imageSize.width * frameSize.height / frameSize.width) : (imageSize.height * frameSize.width / frameSize.height);
    CGRect destination = !isWide ? CGRectMake(0.0, 0.0, imageSize.width, otherValue) : CGRectMake(0.0, 0.0, otherValue, imageSize.height);
    
    [self.scrollView zoomToRect:destination animated:NO];
    [self.scrollView flashScrollIndicators];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
