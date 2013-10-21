//
//  MapVCViewController.m
//  Pictures
//
//  Created by Andrea Houg on 10/4/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import "FlickrPhotoAnnotation.h"
#import "PlaceAnnotation.h"
#import "DisplayImageVC.h"
#import "PhotosFromPlaceTVC.h"
#import "FlickrFetcher.h"

@interface MapVC () <MKMapViewDelegate>

@property (nonatomic, weak) NSDictionary *currentPhoto;
@property (nonatomic, weak) UIImage *selectedImage;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

@implementation MapVC

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize currentPhoto = _currentPhotoOrPlace;
@synthesize selectedImage = _selectedImage;

- (void)updateMapView
{
    if (self.mapView.annotations)
        [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations)
        [self.mapView addAnnotations:self.annotations];
    [self zoomToRegion];

}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapView];
}

#pragma mark - MKMapView delegate methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)detailButtonTapped
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    [spinner startAnimating];
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", NULL);
    dispatch_async(loadingQueue, ^{
        UIImage *image = [[Cacher sharedInstance] getImageForPhoto:self.currentPhoto];
        if (!image) {
            NSLog(@"loading image");
            NSURL *url = [FlickrFetcher urlForPhoto:self.currentPhoto format:FlickrPhotoFormatLarge];
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedImage = image;
            [spinner stopAnimating];
            spinner.hidden = true;
            [self performSegueWithIdentifier:@"showImageFromAnnotation" sender:self];
        });
    });

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showImageFromAnnotation"]) {
        DisplayImageVC *dvc = segue.destinationViewController;
        dvc.photo = self.currentPhoto;
        dvc.image = self.selectedImage;
        dvc.title = [self.currentPhoto objectForKey:@"title"];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
    UIButton *button = [self.delegate mapViewController:self buttonForAnnotation:aView.annotation];
    if (button) {
        FlickrPhotoAnnotation *annot = aView.annotation;
        self.currentPhoto = annot.photo;
        aView.rightCalloutAccessoryView = button;
        [button addTarget:self action:@selector(detailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[FlickrPhotoAnnotation class]]) {
        [self performSegueWithIdentifier:@"showImageFromAnnotation" sender:self];
    }
}

- (void)zoomToRegion
{
    NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
    
    CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
    CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
    
    for(NSValue *value in coordinates) {
        CLLocationCoordinate2D coord = {0.0f, 0.0f};
        [value getValue:&coord];
        if(coord.longitude > maxCoord.longitude) {
            maxCoord.longitude = coord.longitude;
        }
        if(coord.latitude > maxCoord.latitude) {
            maxCoord.latitude = coord.latitude;
        }
        if(coord.longitude < minCoord.longitude) {
            minCoord.longitude = coord.longitude;
        }
        if(coord.latitude < minCoord.latitude) {
            minCoord.latitude = coord.latitude;
        }
    }
    
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
    region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
    region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
    region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
    [self.mapView setRegion:region animated:YES];  
}


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
    self.mapView.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
