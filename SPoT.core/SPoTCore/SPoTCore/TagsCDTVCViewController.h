//
//  TagsCDTVCViewController.h
//  SPoTCore
//
//  Created by Claus Noergaard on 6/5/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface TagsCDTVCViewController : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) UIPopoverController *popOver;

@end
