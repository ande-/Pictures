//
//  DisplayImageVC.m
//  Pictures
//
//  Created by Andrea Houg on 9/16/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "DisplayImageVC.h"
#import "FlickrFetcher.h"

@interface DisplayImageVC ()

@end

@implementation DisplayImageVC

@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize photo = _photo;
@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    CGRect destination = ! isWide ? CGRectMake(0.0, 0.0, imageSize.width, otherValue) : CGRectMake(0.0, 0.0, otherValue, imageSize.height);
    
    [self.scrollView zoomToRect:destination animated:NO];
    
    [self.scrollView flashScrollIndicators];
    [[Cacher sharedInstance] saveToUserDefaults:self.photo];
    
    [[Cacher sharedInstance] cacheImage:self.image forPhoto:self.photo];
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
