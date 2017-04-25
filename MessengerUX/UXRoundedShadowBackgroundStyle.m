//
//  UXRoundedShadowBackgroundStyle.m
//  MessengerUX
//
//  Created by CPU11815 on 4/11/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXRoundedShadowBackgroundStyle.h"

@implementation UXRoundedShadowBackgroundStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cornerRadius = 16;
    }
    
    return self;
}

- (ASControlNode *)getMessageBackground {
    ASControlNode * ret = [[ASControlNode alloc] init];
    ret.clipsToBounds = NO;
    ret.cornerRadius = self.cornerRadius;
    ret.shadowColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
    ret.shadowOffset = CGSizeMake(0, 2);
    ret.shadowOpacity = 1;
    ret.shadowRadius = 4;
    return ret;
}

@end
