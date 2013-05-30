//
//  spotTVC.m
//  SPoT
//
//  Created by cn on 30/05/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "spotTVC.h"
#import "FlickrFetcher.h"

@interface spotTVC ()
@end

@implementation spotTVC

- (void)setTag:(NSString *)tag
{
    _tag = tag;
    NSArray *photos = [FlickrFetcher stanfordPhotos];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tags CONTAINS[cd] %@",tag];
    self.photos = [photos filteredArrayUsingPredicate:predicate];
}

@end

