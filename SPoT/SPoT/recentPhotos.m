//
//  recentPhotos.m
//  SPoT
//
//  Created by Claus Noergaard on 5/30/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "recentPhotos.h"

@implementation recentPhotos

#define RECENT_PHOTOS_KEY @"RecentPhotos"
#define HISTORY_LENGTH 10

+ (NSArray *)allPhotos
{
    NSArray *recentPhotos = [[NSMutableArray alloc] init];
    recentPhotos = [[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_KEY]  ;
    return recentPhotos;
}

+ (void) usePhoto: (NSDictionary *)photo
{
    NSMutableArray *mutableRecentPhotos = [[[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_KEY] mutableCopy];
    if (!mutableRecentPhotos) mutableRecentPhotos = [[NSMutableArray alloc] init];
    
    [mutableRecentPhotos removeObject:photo];
    [mutableRecentPhotos insertObject:photo atIndex:0];
    if (mutableRecentPhotos.count > HISTORY_LENGTH)
        [mutableRecentPhotos removeObjectsInRange:NSMakeRange(HISTORY_LENGTH,mutableRecentPhotos.count-HISTORY_LENGTH)];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableRecentPhotos forKey:RECENT_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

@end
