//
//  UXAttributedTextMessage.m
//  MessengerUX
//
//  Created by CPU11808 on 4/10/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAttributedTextMessage.h"
#import "UXAttributedTextMessageCell.h"

@implementation UXAttributedTextMessage

- (instancetype)initWithContent:(NSString *)string date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXAttributedTextMessageCell class] userInfo:nil];
    if (self) {
        self.ID = [[NSProcessInfo processInfo] globallyUniqueString];
        self.content = string;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
    }
    
    return self;
}

@end
