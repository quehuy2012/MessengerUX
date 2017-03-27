//
//  UXImageBackgroundStyle.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXImageBackgroundStyle.h"

@implementation UXImageBackgroundStyle

- (ASDisplayNode *)getMessageBackground {
    ASImageNode * ret = [[ASImageNode alloc] init];
    ret.clipsToBounds = YES;
    ret.cornerRadius = self.cornerRadius;
    [ret setImage:nil];
    return ret;
}

@end
