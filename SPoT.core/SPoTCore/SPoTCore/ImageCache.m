//
//  ImageCache.m
//  SPoT
//
//  Created by Claus Noergaard on 6/3/13.
//  Copyright (c) 2013 Claus Noergaard. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

+ (NSData *) GetImageData: (NSURL *)ImageUrl
{
    NSData *imageData;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *imageCache = [fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *CacheId = [ImageUrl lastPathComponent];
    NSURL *CacheUrl = [imageCache URLByAppendingPathComponent:CacheId];
    
    imageData = [[NSData alloc] initWithContentsOfURL:CacheUrl];
    if ((imageData!=nil) && !([imageData isEqual:[NSNull null]]))
    {
        return imageData;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    imageData = [[NSData alloc] initWithContentsOfURL:ImageUrl];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    dispatch_queue_t writeQueue = dispatch_queue_create("Write Queue", NULL);
    dispatch_async(writeQueue,
                   ^{
                       [imageData writeToURL:CacheUrl atomically:YES];
                        dispatch_queue_t clearQueue = dispatch_queue_create("Clear Queue", NULL);
                        dispatch_async(clearQueue,
                                      ^{
                                          [ImageCache ClearOldFilesFromCache];
                                      });

                   });
    
        
    return imageData;

}

#define CACHE_SIZE 3000000

+ (void) ClearOldFilesFromCache
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *imageCache = [fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSArray *cachedFiles = [fileManager contentsOfDirectoryAtURL:imageCache
                                      includingPropertiesForKeys:@[NSURLContentAccessDateKey,
                                                                   NSURLFileSizeKey]
                                                         options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                           error:nil ];
    
    NSUInteger totalSize = 0;
    for (NSURL *file in cachedFiles)
    {
        NSNumber *fileSizeBytes;
        [file getResourceValue:&fileSizeBytes forKey:NSURLFileSizeKey error:nil];
        totalSize += [fileSizeBytes unsignedIntegerValue];
    }
    if (totalSize < CACHE_SIZE)
        return;
    
    // sort according to accessdate
    NSArray *sortedArray = [cachedFiles sortedArrayUsingComparator:^(NSURL* obj1,NSURL* obj2) {
        NSDate *acc1;
        NSDate *acc2;
        [obj1 getResourceValue:&acc1 forKey:NSURLContentAccessDateKey error:nil];
        [obj2 getResourceValue:&acc2 forKey:NSURLContentAccessDateKey error:nil];
        return [acc1 compare:acc2];
    }];
    
    //remove old files until we are under cache size
    for (NSURL *file in sortedArray)
    {
        NSNumber *fileSizeBytes;
        [file getResourceValue:&fileSizeBytes forKey:NSURLFileSizeKey error:nil];
        
        [fileManager removeItemAtURL:file error:nil];
        totalSize -= [fileSizeBytes unsignedIntegerValue];
        if (totalSize < CACHE_SIZE)
          break;
    }


}


@end
