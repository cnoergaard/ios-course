//
//  PhotosByTagCDTVC.m
//  SPoTCore
//
//  Created by Claus Noergaard on 6/5/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "PhotosByTagCDTVC.h"

@interface PhotosByTagCDTVC ()

@end

@implementation PhotosByTagCDTVC

#pragma mark - Properties

// When our Model is set here, we update our title to be the Photographer's name
//   and then set up our NSFetchedResultsController to make a request for Photos taken by that Photographer.

- (void)setTag:(Tag *)tag
{
    _tag = tag;
    self.title = tag.name;
    [self setupFetchedResultsController];
}

// Creates an NSFetchRequest for Photos sorted by their title where the whoTook relationship = our Model.
// Note that we have the NSManagedObjectContext we need by asking our Model (the Photographer) for it.
// Uses that to build and set our NSFetchedResultsController property inherited from CoreDataTableViewController.

- (void)setupFetchedResultsController
{
    if (self.tag.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY tag.name = %@", self.tag.name];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.tag.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
