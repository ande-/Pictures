//
//  ItineraryTVC.m
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "ItineraryTVC.h"
#import "Photo.h"

@interface ItineraryTVC ()

@property (strong, nonatomic) NSMutableArray *locations; //the model

@end

@implementation ItineraryTVC

@synthesize vacation = _vacation;
@synthesize locations = _locations;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)locations
{
    if (!_locations) {
        _locations = [[NSMutableArray alloc] init];
    }
    return _locations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadModel];
}

- (void)loadModel
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timeAdded" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"vacation == %@", self.vacation];
    NSError *error;
    NSArray *photos = [self.vacation.managedObjectContext executeFetchRequest:request error:&error];
    
    for (Photo *p in photos) {
        if (![self.locations containsObject:p.location]) {
            [self.locations addObject:p.location];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItineraryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.locations objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
        [segue.destinationViewController performSelector:@selector(setVacation:) withObject:self.vacation];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setLocation:)]) {
        NSString *location = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow].textLabel.text;        [segue.destinationViewController performSelector:@selector(setLocation:) withObject:location];
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showItineraryVacationItem" sender:self];
}

@end
