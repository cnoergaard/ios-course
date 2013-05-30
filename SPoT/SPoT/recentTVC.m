//
//  recentTVC.m
//  SPoT
//
//  Created by cn on 30/05/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "recentTVC.h"
#import "FlickrFetcher.h"
#include "recentPhotos.h"

@interface recentTVC ()
@end

@implementation recentTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [recentPhotos allPhotos];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.photos = [recentPhotos allPhotos];
    [self.tableView reloadData];
}

@end

