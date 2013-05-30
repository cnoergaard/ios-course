//
//  recentPhotos.h
//  SPoT
//
//  Created by Claus Noergaard on 5/30/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recentPhotos : NSObject

+ (void) usePhoto: (NSDictionary *)photo;
+ (NSArray *) allPhotos; // of NSDictonary;

@end
