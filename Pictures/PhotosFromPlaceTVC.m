//
//  PhotosFromPlace.m
//  Pictures
//
//  Created by Andrea Houg on 9/16/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "PhotosFromPlaceTVC.h"
#import "DisplayImageVC.h"
#import "FlickrFetcher.h"
#import "MapVC.h"
#import "FlickrPhotoAnnotation.h"
#import "Cacher.h"

@interface PhotosFromPlaceTVC () <MapVCDelegate>

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) NSDictionary *selectedPhoto;
@end

@implementation PhotosFromPlaceTVC 

@synthesize top50 = _top50;
@synthesize selectedImage = _selectedImage;
@synthesize selectedPhoto = _selectedPhoto;

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = [self.top50 objectAtIndex:indexPath.row];
    NSString *title = [photo valueForKey:FLICKR_PHOTO_TITLE];
    NSString *description = [photo valueForKey:FLICKR_PHOTO_DESCRIPTION];
    cell.textLabel.text = title ? title : @"unknown";
    cell.detailTextLabel.text = description ? description : @"no description";
    
    return cell;
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.top50 count]];
    for (NSDictionary *photo in self.top50) {
        [annotations addObject:[FlickrPhotoAnnotation annotationforPhoto:photo]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showImage"]) {
        DisplayImageVC *dvc = segue.destinationViewController;
        dvc.photo = self.selectedPhoto;
        dvc.image = self.selectedImage;
        dvc.title = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text;

    }
    else if ([segue.identifier isEqualToString:@"showMapOfPhotos"])
    {
        MapVC *mvc = segue.destinationViewController;
        mvc.delegate = self;
        mvc.annotations = [self mapAnnotations];
    }
}

#pragma mark - MapVC delegate methods
- (UIImage *)mapViewController:(MapVC *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrPhotoAnnotation *annot = (FlickrPhotoAnnotation *)annotation;
    NSDictionary *photo = annot.photo;
    UIImage *image = [[Cacher sharedInstance] getImageForPhotoId:[photo objectForKey:FLICKR_PHOTO_ID]];
    if (!image) {
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        NSLog(@"loading callout image");
    }
    [[Cacher sharedInstance] cacheImage:image forPhotoId:[photo valueForKey:FLICKR_PHOTO_ID]];
    return image;
}

- (UIButton *)mapViewController:(MapVC *)sender buttonForAnnotation:(id <MKAnnotation>)annotation
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 30, 20);
    [button setTitle:@"i" forState:UIControlStateNormal];
    return button;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    NSDictionary *photo = [self.top50 objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    self.selectedPhoto = photo;
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", NULL);
    dispatch_async(loadingQueue, ^{
        UIImage *image = [[Cacher sharedInstance] getImageForPhotoId:[self.selectedPhoto objectForKey:FLICKR_PHOTO_ID]];
        if (!image) {
            NSLog(@"loading image");
            NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [[Cacher sharedInstance] cacheImage:image forPhotoId:[self.selectedPhoto valueForKey:FLICKR_PHOTO_ID]];

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedImage = image;
            [spinner stopAnimating];
            spinner.hidden = true;
            [self performSegueWithIdentifier:@"showImage" sender:self];
        });
    });
}

@end
