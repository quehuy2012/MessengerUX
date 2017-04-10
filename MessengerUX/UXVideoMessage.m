//
//  UXVideoMessage.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXVideoMessage.h"
#import "UXVideoMessageCell.h"

@implementation UXVideoMessage

- (instancetype)initWithVideoURL:(NSURL *)videoURL withRatio:(CGFloat)ratio date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXVideoMessageCell class] userInfo:nil];
    if (self) {
        self.videoURL = videoURL;
        self.ratio = ratio;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
    }
    
    return self;
}

@end
