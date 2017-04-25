//
//  UXAlbumMessage.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAlbumMessage.h"
#import "UXAlbumMessageCell.h"

@implementation UXAlbumMessage

- (instancetype)initWithImages:(NSArray<UIImage *> *)images date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXAlbumMessageCell class] userInfo:nil];
    if (self) {
        self.images = images;
        self.imageURLs = nil;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
    }
    
    return self;
}

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXAlbumMessageCell class] userInfo:nil];
    if (self) {
        self.images = nil;
        self.imageURLs = imageURLs;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
    }
    
    return self;
}

@end
