//
//  RecentPhotosTVC.m
//  Pictures
//
//  Created by Andrea Houg on 9/14/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "FlickrFetcher.h"
#import "DisplayImageVC.h"
#import "Cacher.h"

@interface RecentPhotosTVC ()

@property (strong, nonatomic) NSDictionary *selectedPhoto;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation RecentPhotosTVC
@synthesize tableView = _tableView;

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
    [super viewDidLoad];
    self.title = @"Recent Photos";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentsOrder = [defaults objectForKey:@"PicturesApp.RecentsOrder"];
    return recentsOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *recents = [defaults objectForKey:@"PicturesApp.Recents"];
    NSArray *recentsOrder = [defaults objectForKey:@"PicturesApp.RecentsOrder"];
    if (recents && recentsOrder) {
        NSString *key = [recentsOrder objectAtIndex:indexPath.row];
        NSDictionary *photo = [recents objectForKey:key];
        cell.textLabel.text = [photo objectForKey:@"title"];
        cell.detailTextLabel.text = key;
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showImageFromRecents"]) {
        DisplayImageVC *dvc = segue.destinationViewController;
        dvc.photo = self.selectedPhoto;
        dvc.image = self.selectedImage;
        dvc.title = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text;

    }
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *recents = [defaults objectForKey:@"PicturesApp.Recents"];
    NSArray *recentsOrder = [defaults objectForKey:@"PicturesApp.RecentsOrder"];
    NSString *key = [recentsOrder objectAtIndex:indexPath.row];
    NSDictionary *photo = [recents objectForKey:key];
    self.selectedPhoto = photo;

    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", NULL);
    dispatch_async(loadingQueue, ^{
        UIImage *image = [[Cacher sharedInstance] getImageForPhoto:self.selectedPhoto];
        if (!image) {
            NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            NSLog(@"loading image");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedImage = image;
            [spinner stopAnimating];
            spinner.hidden = true;
            [self performSegueWithIdentifier:@"showImageFromRecents" sender:self];
        });
    });
}

@end
