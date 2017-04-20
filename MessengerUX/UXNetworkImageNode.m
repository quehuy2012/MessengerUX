//
//  UXNetworkImageNode.m
//  MessengerUX
//
//  Created by CPU11815 on 4/19/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXNetworkImageNode.h"
#import "UXImageCache.h"
#import "UXImageDownloader.h"

@implementation UXNetworkImageNode

// Override to use custom cacher and downloader
- (instancetype)init {
    return [self initWithCache:(id <ASImageCacheProtocol>)[[UXImageDownloader defaultInstance] imageCache] downloader:[UXImageDownloader defaultInstance]];
}

@end
