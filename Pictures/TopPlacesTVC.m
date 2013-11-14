//
//  TopPlacesTVC.m
//  Pictures
//
//  Created by Andrea Houg on 9/14/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"
#import "FLickrAPIKey.h"
#import "PhotosFromPlaceTVC.h"
#import "MapVC.h"
#import "PlaceAnnotation.h"

@interface TopPlacesTVC ()
@property (strong, nonatomic) NSArray *top50;

@end

@implementation TopPlacesTVC

@synthesize places = _places;
@synthesize top50 = _top50;
- (NSArray *)places
{
    if (!_places) {
        _places = [FlickrFetcher topPlaces];
    }
    return _places;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"Top Places";
    [self.navigationController setToolbarHidden:NO];
}


- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.places count]];
    for (NSDictionary *place in self.places) {
        [annotations addObject:[PlaceAnnotation annotationforPlace:place]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPhotosFromPlace"]) {
        PhotosFromPlaceTVC *dvc = segue.destinationViewController;
        dvc.top50 = self.top50;
        dvc.title = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text;
    }
    else if ([segue.identifier isEqualToString:@"showMap"])
    {
        MapVC *mvc = segue.destinationViewController;
        mvc.annotations = [self mapAnnotations];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"locationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *cityName = [[self.places objectAtIndex:indexPath.row] valueForKey:@"woe_name"];
    cell.textLabel.text = cityName;
    NSString *stateAndCountry = [[[[self.places objectAtIndex:indexPath.row] valueForKey:FLICKR_PLACE_NAME]stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@, ", cityName] withString:@""] stringByReplacingOccurrencesOfString:@" ," withString:@""];
    cell.detailTextLabel.text = stateAndCountry;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", NULL);
    dispatch_async(loadingQueue, ^{
        NSArray *top50 = [FlickrFetcher photosInPlace:[[FlickrFetcher topPlaces] objectAtIndex:indexPath.row] maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.top50 = top50;
            [spinner stopAnimating];
            spinner.hidden = true;
            [self performSegueWithIdentifier:@"showPhotosFromPlace" sender:self];
        });
    });
}

@end
