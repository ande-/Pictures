//
//  TopPlacesTVC.m
//  Pictures
//
//  Created by Andrea Houg on 9/14/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *stateAndCountry = [[[[self.places objectAtIndex:indexPath.row] valueForKey:@"_content"]stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@, ", cityName] withString:@""] stringByReplacingOccurrencesOfString:@" ," withString:@""];
    cell.detailTextLabel.text = stateAndCountry;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

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
