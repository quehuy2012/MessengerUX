//
//  UXTitleMessage.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXTitleMessage.h"
#import "UXTitleMessageCell.h"

@implementation UXTitleMessage

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithCellNodeClass:[UXTitleMessageCell class] userInfo:title];
    if (self) {
        self.title = title;
    }
    
    return self;
}

@end
