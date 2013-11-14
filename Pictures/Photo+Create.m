//
//  Photo+Create.m
//  Pictures
//
//  Created by Andrea Houg on 11/3/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "Photo+Create.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"

@implementation Photo (Create)

+ (Photo *)photoWithPhoto:(NSDictionary *)photo inVacation:(Vacation *)vacation inManagedObectContext:(NSManagedObjectContext *)context
{
    Photo *retval = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    retval.uniqueId =[photo objectForKey:FLICKR_PHOTO_ID];
    retval.vacation = vacation;
    NSArray *location = [[photo objectForKey:FLICKR_PHOTO_PLACE_NAME] componentsSeparatedByString:@", "];
    NSString *string = [NSString stringWithFormat:@", %@", [location objectAtIndex:1]];
    retval.location = [[location objectAtIndex:0] stringByAppendingString:string];
    retval.title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    retval.urlPath = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge].absoluteString;
    retval.timeAdded = [NSDate date];
    
    //tags
    NSString *s = [photo objectForKey:FLICKR_TAGS];
    NSArray *a = [s componentsSeparatedByString:@" "];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    NSArray *existingTags = [context executeFetchRequest:request error:&error];
    NSMutableDictionary *existingTagsByName = [[NSMutableDictionary alloc] init];
    for (Tag *tag in existingTags) {
        [existingTagsByName setObject:tag forKey:tag.name];
    }
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (NSString *tagName in a) {
        if ([tagName rangeOfString:@":"].location == NSNotFound) {
            Tag *reuseTag = [existingTagsByName objectForKey:tagName];
            if (reuseTag)
            {
                reuseTag.photoCount = [NSNumber numberWithInt:[reuseTag.photoCount integerValue] + 1];
                [set addObject:reuseTag];
            }
            else {
                Tag *newTag = [Tag tagForString:tagName inManagedObjectContext:context];
                newTag.photoCount = [NSNumber numberWithInt:1];
                [set addObject:newTag];
            }
        }
    }
    retval.tags = set;
    
    return retval;
}

@end
