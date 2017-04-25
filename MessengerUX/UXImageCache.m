//
//  UXImageCache.m
//  MessengerUX
//
//  Created by CPU11815 on 4/19/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXImageCache.h"

@implementation UXImageCache

#pragma mark - ASImageCacheProtocol

- (void)cachedImageWithURL:(NSURL *)URL
             callbackQueue:(dispatch_queue_t)callbackQueue
                completion:(ASImageCacherCompletion)completion {
    
//    __weak typeof(self) weakSelf = self;
    dispatch_async(callbackQueue ? callbackQueue : dispatch_get_main_queue(), ^{
//        NSURLRequest * request = [NSURLRequest requestWithURL:URL];
        
//        UIImage * image = [weakSelf imageforRequest:request withAdditionalIdentifier:nil];
        
        if (completion) {
//            completion(image);
            completion(nil);
        }
        
    });
}

- (nullable id <ASImageContainerProtocol>)synchronouslyFetchedCachedImageWithURL:(NSURL *)URL {
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    return [self imageforRequest:request withAdditionalIdentifier:nil];
}

//- (void)clearFetchedImageFromCacheWithURL:(NSURL *)URL {
//    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
//    [self removeImageforRequest:request withAdditionalIdentifier:nil];
//}

@end
