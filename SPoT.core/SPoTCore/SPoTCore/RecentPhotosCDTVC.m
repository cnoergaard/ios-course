//
//  RecentPhotosCDTVC.m
//  SPoTCore
//
//  Created by Claus Noergaard on 6/6/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "RecentPhotosCDTVC.h"
#import "ManagedDocumentCache.h"

@interface RecentPhotosCDTVC ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation RecentPhotosCDTVC

- (void) viewWillAppear:(BOOL)animated
{
    [self useDemoDocument];
}

#pragma mark - Properties


// Creates an NSFetchRequest for Photos sorted by their title where the whoTook relationship = our Model.
// Note that we have the NSManagedObjectContext we need by asking our Model (the Photographer) for it.
// Uses that to build and set our NSFetchedResultsController property inherited from CoreDataTableViewController.


- (void)setupFetchedResultsController
{
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastAccess" ascending:NO selector:@selector(compare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"lastAccess != nil"];
        request.fetchLimit = 10;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Tags Document"];
    UIManagedDocument *document = [ManagedDocumentCache forFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
}

#pragma mark - Refreshing


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        [self setupFetchedResultsController];
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
