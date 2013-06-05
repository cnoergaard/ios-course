//
//  ManagedDocumentCache.m
//  SPoTCore
//
//  Created by Claus Noergaard on 6/5/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "ManagedDocumentCache.h"

@implementation ManagedDocumentCache

static NSMutableDictionary *cache = nil;

+ (UIManagedDocument *)forFileURL:(NSURL*)URL
{
    UIManagedDocument *doc;

    @synchronized(self)
    {
      if (cache==nil)
        cache = [[NSMutableDictionary alloc] init];
        doc = cache[[URL absoluteString]];
        if (doc==nil)
        {
           doc = [[UIManagedDocument alloc] initWithFileURL:URL];
           cache[[URL absoluteString]] = doc;
        }
    }
    
    return doc;
    
}

@end
