//
//  UXRoundedBackgroundStyle.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXRoundedBackgroundStyle.h"

@implementation UXRoundedBackgroundStyle

- (ASDisplayNode *)getMessageBackground {
    ASDisplayNode * ret = [[ASDisplayNode alloc] init];
    ret.clipsToBounds = YES;
    ret.cornerRadius = self.cornerRadius;
    return ret;
}

@end
