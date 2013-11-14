
//
//  TagsTVC.m
//  Pictures
//
//  Created by Andrea Houg on 10/27/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "TagsTVC.h"
#import "Tag.h"

@interface TagsTVC ()

@end

@implementation TagsTVC

@synthesize vacation = _vacation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpFetchedResultsController];
}

- (void)setUpFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoCount" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY photos.vacation.title == %@", self.vacation.title];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacation.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    

}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    cell.detailTextLabel.text = [tag.photos count] > 1 ? [NSString stringWithFormat: @"%d photos", [tag.photos count]] : [NSString stringWithFormat: @"%d photo", [tag.photos count]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
        [segue.destinationViewController performSelector:@selector(setVacation:) withObject:self.vacation];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setTag:)]) {
        Tag *tag = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [segue.destinationViewController performSelector:@selector(setTag:) withObject:tag];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showTagsVacationItem" sender:self];
}

@end
