//
//  DisplayImageVC.m
//  Pictures
//
//  Created by Andrea Houg on 9/16/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "DisplayImageVC.h"
#import "FlickrFetcher.h"
#import "Vacation+Create.h"
#import "Photo+Create.h"
#import "VacationHelper.h"

@interface DisplayImageVC ()

@property (nonatomic) BOOL visited;  //TODO make setter actually do a query
@property (strong, nonatomic) IBOutlet UIBarButtonItem *visitButton;
@property (strong, nonatomic) UIManagedDocument *vacationDocument;

@end

@implementation DisplayImageVC

@synthesize photo = _photo;
@synthesize visited = _visited;
@synthesize vacationDocument = _vacationDocument;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[Cacher sharedInstance] saveToUserDefaults:self.photo];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.visited = NO;
        [VacationHelper openVacation:@"My Vacation" usingBlock:^(UIManagedDocument *vacationDoc) {

            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
            request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:nil]];
            request.predicate = [NSPredicate predicateWithFormat:@"vacation.title == %@", @"My Vacation"];
            NSError *error;
            NSArray *photos = [vacationDoc.managedObjectContext executeFetchRequest:request error:&error];
            for (Photo *photo in photos) {
                if ([photo.uniqueId isEqualToString:[self.photo objectForKey:FLICKR_PHOTO_ID]]) {
                    self.visited = YES;
                    [self.visitButton setTitle:@"Unvisit"];
            
                }
            }
        }];
}

- (IBAction)visitPressed:(UIBarButtonItem *)sender
{
    if (!self.visited) {
        self.visited = true;
        [sender setTitle:@"Unvisit"];
        [VacationHelper openVacation:@"My Vacation" usingBlock:^(UIManagedDocument *vacationDoc){
            self.vacationDocument = vacationDoc;
            [self addToVacation];
        }];
        
    }
    else {
        self.visited = false;
        [sender setTitle:@"Visit"];
        //remove photo from vacation- have to do a whole freaking fetch request
        NSError *error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"uniqueId == %@", [self.photo objectForKey:FLICKR_PHOTO_ID]];
        NSArray *fetchedObjects = [self.vacationDocument.managedObjectContext executeFetchRequest:request error:&error];
        
        for (NSManagedObject *product in fetchedObjects) {
            [self.vacationDocument.managedObjectContext deleteObject:product];
        }
    }
}

- (void)addToVacation
{
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate = [NSPredicate predicateWithFormat:@"title == %@", @"My Vacation"];
    NSArray *fetchedObjects = [self.vacationDocument.managedObjectContext executeFetchRequest:request error:&error];
    
    Vacation *vacation = [fetchedObjects lastObject];
    
    [Photo photoWithPhoto:self.photo inVacation:vacation inManagedObectContext:self.vacationDocument.managedObjectContext];
    [self.vacationDocument saveToURL:self.vacationDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"it saved");
        }
    }];
}



@end
