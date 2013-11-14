//
//  VirtualVacationListTVC.m
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "VirtualVacationListTVC.h"
#import "Vacation.h"
#import "Vacation+Create.h"
#import "VacationHelper.h"
#import "AppDelegate.h"
#import "VacationOptionsTVC.h"
#import "Photo.h"

@interface VirtualVacationListTVC ()
@property (nonatomic, strong) UIManagedDocument *vacationDoc;
@end

@implementation VirtualVacationListTVC

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
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    
    if (![VacationHelper managedObjectContext]) {
        [VacationHelper openVacation:@"My Vacation" usingBlock:^(UIManagedDocument *document){
            [self actualSetup:document.managedObjectContext];
        }];
    }
    else
    {
        [self actualSetup:[VacationHelper managedObjectContext]];
    }

}
- (void)actualSetup:(NSManagedObjectContext *)context
{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:nil]];
        // no predicate because we want ALL the Vacations
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
 
    

}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) { //is this instead of setting number of rows?
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Vacation *vacation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = vacation.title;
    
    return cell;

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        NSManagedObject *vacation = [self.fetchedResultsController objectAtIndexPath:indexPath];

        [segue.destinationViewController performSelector:@selector(setVacation:) withObject:vacation];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showVacationOptions" sender:self];
}

@end