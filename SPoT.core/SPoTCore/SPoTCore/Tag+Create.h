//
//  Tag+Create.h
//  SPoTCore
//
//  Created by Claus Noergaard on 6/5/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)
+ (Tag *)tagWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
