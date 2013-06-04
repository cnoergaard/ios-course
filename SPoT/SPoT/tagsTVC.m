//
//  tagsTVC.m
//  SPoT
//
//  Created by cn on 30/05/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "tagsTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface tagsTVC () <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSArray *tags; // of NSString *
@property (strong, nonatomic) NSMutableOrderedSet *uniqueTags; // of NSString *
@property (strong, nonatomic) NSArray *photos; // of dicts


@end

@implementation tagsTVC

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

 - (void)viewDidLoad
{
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self refresh];
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Photos";
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    self.popOver = pc;
    [detailViewController setSplitBarViewBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
   id detailViewController = [self.splitViewController.viewControllers lastObject];
   self.popOver = nil;
   [detailViewController setSplitBarViewBarButtonItem:nil];
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t downloadQueue = dispatch_queue_create("Flicker Fetcher Queue", NULL);
    dispatch_async(downloadQueue,
                   ^{
                       [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                       NSArray * photos = [FlickrFetcher stanfordPhotos];
                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          self.photos = photos;
                                          [self.refreshControl endRefreshing];
                                      });
                   });
    
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    self.tags = nil;
    self.uniqueTags = nil;
    [self.tableView reloadData];
}

- (NSArray *)tags
{
    NSMutableArray *mut_tags;
    if (!_tags)
    {
      mut_tags = [[NSMutableArray alloc ] init];

      for (NSDictionary *dict in self.photos)
      {
        NSString *mytags = dict[@"tags"];
        for  (NSString *tag in [mytags componentsSeparatedByString:@" "])
        {
            if (![tag isEqualToString:@"cs193pspot"] &&
                ![tag isEqualToString:@"portrait"] &&
                ![tag isEqualToString:@"landscape"])
          [mut_tags addObject:tag];
        }
      }
      [mut_tags sortUsingSelector:@selector(compare:)];
      _tags = mut_tags;
    }
        
    return _tags;
}

- (NSMutableOrderedSet *)uniqueTags
{
  if (_uniqueTags==nil)
  {
     _uniqueTags = [[NSMutableOrderedSet alloc] init];
     [_uniqueTags addObjectsFromArray:self.tags];
  }
  return _uniqueTags;
}

- (NSUInteger) countTag: (NSString *)tag
{
    int Count = 0;
    for (NSString *ittag in self.tags)
    {
        if ([ittag isEqualToString:tag])
            Count++;
    }
    return Count;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.uniqueTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TagsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *tag = self.uniqueTags[indexPath.row];
    
    cell.textLabel.text = [tag capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photo(s)", [self countTag:tag]];
    return cell;
}

#pragma mark - Segue

// prepares for the "Show Image" segue by seeing if the destination view controller of the segue
//  understands the method "setImageURL:"
// if it does, it sends setImageURL: to the destination view controller with
//  the URL of the photo that was selected in the UITableView as the argument
// also sets the title of the destination view controller to the photo's title

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Tag"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    
                    NSString *tag = self.uniqueTags[indexPath.row];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tags CONTAINS[cd] %@",tag];
                    NSArray *photos = [self.photos filteredArrayUsingPredicate:predicate];
                    NSArray *sortedPhotos = [photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending:YES]]];

                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:sortedPhotos];
                    [segue.destinationViewController setTitle:[tag capitalizedString]];
                }
            }
        }
    }
}



@end
