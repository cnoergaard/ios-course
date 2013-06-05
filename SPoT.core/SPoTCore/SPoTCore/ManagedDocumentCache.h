//
//  ManagedDocumentCache.h
//  SPoTCore
//
//  Created by Claus Noergaard on 6/5/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagedDocumentCache : NSObject
+ (UIManagedDocument *)forFileURL:(NSURL*)URL;
@end
