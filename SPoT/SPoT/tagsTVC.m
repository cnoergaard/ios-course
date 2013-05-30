//
//  tagsTVC.m
//  SPoT
//
//  Created by cn on 30/05/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "tagsTVC.h"
#import "FlickrFetcher.h"

@interface tagsTVC ()
@property (strong, nonatomic) NSArray *photos; // of dicts
@property (strong, nonatomic) NSArray *tags; // of NSString *
@property (strong, nonatomic) NSMutableOrderedSet *uniqueTags; // of NSString *


@end

@implementation tagsTVC

- (NSArray *)photos
{
    if (!_photos) _photos = [FlickrFetcher stanfordPhotos];
    return _photos;
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

                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photos];
                    [segue.destinationViewController setTitle:[tag capitalizedString]];
                }
            }
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
