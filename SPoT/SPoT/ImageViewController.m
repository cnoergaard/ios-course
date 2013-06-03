//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL doAutoZoom;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation ImageViewController

// resets the image whenever the URL changes

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)setTitle:(NSString *)title
{
    super.title =title;
    self.titleBarItem.title =title;
}

// fetches the data from the URL
// turns it into an image
// adjusts the scroll view's content size to fit the image
// sets the image as the image view's image

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        [self.spinner startAnimating];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("Download Queue", NULL);
        dispatch_async(downloadQueue,
                       ^{
                           [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                           NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           UIImage *image = [[UIImage alloc] initWithData:imageData];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 if (image) {
                                     self.scrollView.contentSize = image.size;
                                     self.imageView.image = image;
                                     self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                                     [self setZoom];
                                 }
                                 [self.spinner stopAnimating];
                              });
                       });
    }
}



- (void) scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.doAutoZoom = NO;
}

- (void) setZoom
{
    float zoomh = self.scrollView.bounds.size.height/self.imageView.image.size.height;
    float zoomw = self.scrollView.bounds.size.width/self.imageView.image.size.width;
    self.scrollView.zoomScale = MAX(zoomh,zoomw);
    self.scrollView.minimumZoomScale = MIN(zoomh,zoomw);
    self.scrollView.maximumZoomScale = 10.0;

    self.doAutoZoom = YES;
}

- (void) viewDidLayoutSubviews
{
    if (self.doAutoZoom)
    {
      [self setZoom];
    }
}

// lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

// returns the view which will be zoomed when the user pinches
// in this case, it is the image view, obviously
// (there are no other subviews of the scroll view in its content area)

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// add the image view to the scroll view's content area
// setup zooming by setting min and max zoom scale
//   and setting self to be the scroll view's delegate
// resets the image in case URL was set before outlets (e.g. scroll view) were set

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.1;
    self.scrollView.maximumZoomScale = 10.0;
    self.scrollView.delegate = self;
    [self resetImage];
    self.splitBarViewBarButtonItem = self.splitBarViewBarButtonItem;
    self.title = self.title;
}

-(void) setSplitBarViewBarButtonItem:(UIBarButtonItem *)button
{
    UIToolbar *toolbar = [self toolbar];
    NSMutableArray *toolbarItems = [toolbar.items mutableCopy];
    if (_splitBarViewBarButtonItem)
        [toolbarItems removeObject:_splitBarViewBarButtonItem];
    if (button)
        [toolbarItems insertObject:button atIndex:0];
    toolbar.items = toolbarItems;
    _splitBarViewBarButtonItem = button;
}


@end
