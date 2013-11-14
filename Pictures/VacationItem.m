//
//  VacationItem.m
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "VacationItem.h"
#import "Photo.h"
#import "DisplayImageVC.h"
#import "FlickrFetcher.h"

@interface VacationItem ()

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) NSString *selectedPhotoId;

@end

@implementation VacationItem

@synthesize vacation = _vacation;
@synthesize location = _location;
@synthesize selectedImage = _selectedImage;
@synthesize selectedPhotoId = _selectedPhotoId;
@synthesize tag = _tag;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setLocation:(NSString *)location
{
    _location = location;
    [self setupFetchedResultsControllerForLocationItem];
}

- (void)setTag:(NSString *)tag
{
    _tag = tag;
    [self setupFetchedResultsControllerforTagItem];
}


- (void)setupFetchedResultsControllerForLocationItem
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES selector:nil]];
    request.predicate = [NSPredicate predicateWithFormat:@"vacation == %@ AND location == %@", self.vacation, self.location];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacation.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    

    
}

- (void)setupFetchedResultsControllerforTagItem
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES selector:nil]];
    request.predicate = [NSPredicate predicateWithFormat:@"vacation == %@ AND ANY tags == %@", self.vacation, self.tag];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacation.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) { //is this instead of setting number of rows?
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Photo *p =[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = p.title;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setImage:)]) {
        [segue.destinationViewController performSelector:@selector(setImage:) withObject:self.selectedImage];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setPhotoId:)]) {
        [segue.destinationViewController performSelector:@selector(setPhotoId:) withObject:self.selectedPhotoId];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    self.selectedPhotoId = photo.uniqueId;
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", NULL);
    dispatch_async(loadingQueue, ^{
        UIImage *image = [[Cacher sharedInstance] getImageForPhotoId:photo.uniqueId];
        if (!image) {
            NSLog(@"loading image");
            NSURL *url = [NSURL URLWithString:photo.urlPath];
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [[Cacher sharedInstance] cacheImage:image forPhotoId:photo.uniqueId];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedImage = image;
            [spinner stopAnimating];
            spinner.hidden = true;
            [self performSegueWithIdentifier:@"showVacationImage" sender:self];
        });
    });
}


@end
