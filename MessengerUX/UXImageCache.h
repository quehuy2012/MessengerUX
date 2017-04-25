//
//  UXImageCache.h
//  MessengerUX
//
//  Created by CPU11815 on 4/19/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AFAutoPurgingImageCache.h>

@interface UXImageCache : AFAutoPurgingImageCache <ASImageCacheProtocol>

@end
