//
//  UXLocationMessage.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXLocationMessage.h"
#import "UXLocationMessageCell.h"

@implementation UXLocationMessage

- (instancetype)initWithLatitude:(double)latitude andLongtide:(double)longtitude date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXLocationMessageCell class] userInfo:nil];
    if (self) {
        self.latitude = latitude;
        self.longtitude = longtitude;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
    }
    
    return self;
}

@end
