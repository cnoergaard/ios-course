//
//  ImageCache.h
//  SPoT
//
//  Created by Claus Noergaard on 6/3/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+ (NSData *) GetImageData: (NSURL *)ImageUrl;

@end
