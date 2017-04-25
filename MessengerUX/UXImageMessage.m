//
//  UXImageMessage.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXImageMessage.h"
#import "UXSingleImageMessageCell.h"

@implementation UXImageMessage

- (instancetype)initWithImage:(UIImage *)image date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXSingleImageMessageCell class] userInfo:nil];
    if (self) {
        self.ID = [[NSProcessInfo processInfo] globallyUniqueString];
        self.image = image;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
        self.ratio = image.size.height / image.size.width;
    }
    
    return self;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL withRatio:(CGFloat)ratio date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXSingleImageMessageCell class] userInfo:nil];
    if (self) {
        self.ID = [[NSProcessInfo processInfo] globallyUniqueString];
        self.imageURL = imageURL;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
        self.ratio = ratio;
    }
    
    return self;
}

@end
