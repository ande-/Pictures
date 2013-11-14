//
//  Cacher.m
//  Pictures
//
//  Created by Andrea Houg on 10/16/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import "Cacher.h"
#import "FlickrFetcher.h"

@interface Cacher()

@property NSString *directoryPath;

@end


@implementation Cacher

@synthesize directoryPath = _directoryPath;

+ (id)sharedInstance
{
    static Cacher *instance;
    static dispatch_once_t thing;
    dispatch_once(&thing, ^{
        instance = [[Cacher alloc] init];
    });
    return instance;
}

- (void)saveToUserDefaults:(NSDictionary *)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *recents = [[defaults objectForKey:@"PicturesApp.Recents"] mutableCopy];
    if (!recents) {
        recents = [[NSMutableDictionary alloc] init];
    }
    NSString *key = [photo objectForKey:FLICKR_PHOTO_ID];
    [recents setObject:photo forKey:key];
    [defaults setObject:recents forKey:@"PicturesApp.Recents"];
    
    NSMutableArray *recentsOrder = [[defaults objectForKey:@"PicturesApp.RecentsOrder"] mutableCopy];
    if (!recentsOrder) {
        recentsOrder = [[NSMutableArray alloc] init];
    }
    if (![recentsOrder containsObject:key]) {
        [recentsOrder insertObject:key atIndex:0];
    }
    [defaults setObject:recentsOrder forKey:@"PicturesApp.RecentsOrder"];
    
    [defaults synchronize];
}

- (void)cacheImage:(UIImage *)image forPhotoId:(NSString *)uniqueId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSURL *rootUrl = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    self.directoryPath = [rootUrl.path stringByAppendingPathComponent:@"FlickrPhotoCache"];
    NSString *filePath = [self.directoryPath stringByAppendingPathComponent:uniqueId];
    if (![fileManager fileExistsAtPath:self.directoryPath])
    {
        [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:self.directoryPath] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    [fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 0.7) attributes:nil];
    
    //totaling size
    NSError *contentsError;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:self.directoryPath error:&contentsError];
    int directorySize = 0;
    for (NSString *path in files) {
        NSError *attributesError = nil;
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:self.directoryPath error:&attributesError];
        int fileSize = [fileAttributes fileSize]; //in KB
        directorySize += fileSize;
    }
    
    //finding which to remove
    if (directorySize > 10 * 1024) {
        NSString *oldestPath;
        NSDate *oldest = nil;
        for (NSString *path in files) {
            NSError *attributesError = nil;
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[self.directoryPath stringByAppendingPathComponent:path] error:&attributesError];
            NSDate *date = [fileAttributes valueForKey:NSFileCreationDate];
            if ([oldest compare:date] == NSOrderedDescending || oldest == nil)
            {
                oldest = date;
                oldestPath = path;
            }
        }
        NSError *removalError;
        [fileManager removeItemAtPath:[self.directoryPath stringByAppendingPathComponent:oldestPath] error:&removalError];
    }

}

- (UIImage *)getImageForPhotoId:(NSString *)uniqueId
{
    NSData *contents = [[NSFileManager defaultManager] contentsAtPath:[self.directoryPath stringByAppendingPathComponent:uniqueId]];
    return [UIImage imageWithData:contents];
}

@end
