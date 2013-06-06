//
//  PhotosCDTVC.m
//  SPoTCore
//
//  Created by Claus Noergaard on 6/6/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "PhotosCDTVC.h"
#import "Photo.h"
#import "ImageViewController.h"
#import "TagsCDTVCViewController.h"


@interface PhotosCDTVC ()

@end

@implementation PhotosCDTVC

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (photo.thumbnail==nil)
    {
        NSURL *url = [NSURL URLWithString:photo.thumbnailURL];
        dispatch_queue_t downloadQueue = dispatch_queue_create("Thumbnail - Download Queue", NULL);
        dispatch_async(downloadQueue,
                       ^{
                          [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                          NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                          [photo.managedObjectContext performBlock:^{
                              photo.thumbnail = imageData;
                          }];
                       });
    
    }
}

#pragma mark - UITableViewDataSource

// Loads up the cell for a given row by getting the associated Photo from our NSFetchedResultsController.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    if (photo.thumbnail!=nil)
        cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
    
    return cell;
    
}

#pragma mark - segways

- (id)splitViewDetailWithBarButtonItem
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if (![detail respondsToSelector:@selector(setSplitBarViewBarButtonItem:)] ||
        ![detail respondsToSelector:@selector(splitBarViewBarButtonItem)])
        detail = nil;
    return detail;
}

- (void)transferSplitViewBarButtomItemToViewController:(id) destinationViewController
{
    UIBarButtonItem *splitViewbarButtonItem = [[self splitViewDetailWithBarButtonItem] splitBarViewBarButtonItem];
    [[self splitViewDetailWithBarButtonItem] setSplitBarViewBarButtonItem:splitViewbarButtonItem];
    if (splitViewbarButtonItem) [destinationViewController setSplitBarViewBarButtonItem:splitViewbarButtonItem];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                [self transferSplitViewBarButtomItemToViewController:segue.destinationViewController];
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    photo.lastAccess = [NSDate date];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:[NSURL URLWithString:photo.imageURL]];
                    [segue.destinationViewController setTitle:photo.subtitle];
                    id delegate = self.splitViewController.delegate;
                    if ([delegate respondsToSelector:@selector(popOver)])
                        [[delegate popOver] dismissPopoverAnimated:YES];
                }
            }
        }
    }
}

@end
