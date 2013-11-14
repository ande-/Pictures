//
//  Photo.h
//  Pictures
//
//  Created by Andrea Houg on 11/14/13.
//  Copyright (c) 2013 Andrea Houg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag, Vacation;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * urlPath;
@property (nonatomic, retain) NSDate * timeAdded;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) Vacation *vacation;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
