//
//  Photo.h
//  SPoTCore
//
//  Created by Claus Noergaard on 6/6/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSDate * lastAccess;
@property (nonatomic, retain) Photographer *whoTook;
@property (nonatomic, retain) NSSet *tag;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagObject:(Tag *)value;
- (void)removeTagObject:(Tag *)value;
- (void)addTag:(NSSet *)values;
- (void)removeTag:(NSSet *)values;

@end
