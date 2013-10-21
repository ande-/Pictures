//
//  MapVCViewController.h
//  Pictures
//
//  Created by Andrea Houg on 10/4/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

@class MapVC;

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapVCDelegate <NSObject>
- (UIImage *)mapViewController:(MapVC *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
- (UIButton *)mapViewController:(MapVC *)sender buttonForAnnotation:(id <MKAnnotation>)annotation;

@end

@interface MapVC : UIViewController

@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id<MapVCDelegate> delegate;

@end
