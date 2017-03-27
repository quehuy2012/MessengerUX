//
//  UXSingleImageMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXSingleImageMessageCell.h"

#import "UXMessageCellConfigure.h"
#import "UXMessageBackgroundStyle.h"
#import "UXSpeaker.h"

@interface UXSingleImageMessageCell ()

@property (nonatomic) ASDisplayNode * imageContentNode;
@property (nonatomic) CGFloat imageDimentionRatio;

@end

@implementation UXSingleImageMessageCell

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImage:(UIImage *)image {
    self = [self initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.imageContentNode = [[ASImageNode alloc] init];
        self.imageContentNode.cornerRadius = [configure getMessageBackgroundStyle].cornerRadius;
        self.imageContentNode.style.maxWidth = ASDimensionMake(240);
        self.imageDimentionRatio = image.size.height / image.size.width;
        ((ASImageNode *)self.imageContentNode).image = image;
        
        [self addSubnode:self.imageContentNode];
    }
    
    return self;
}

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImageURL:(NSURL *)imageURL ratio:(CGFloat)ratio {
    self = [self initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.imageContentNode = [[ASNetworkImageNode alloc] init];
        self.imageContentNode.style.maxWidth = ASDimensionMake(240);
        self.imageDimentionRatio = ratio;
        ((ASNetworkImageNode *)self.imageContentNode).URL = imageURL;
        
        [self addSubnode:self.imageContentNode];
    }
    
    return self;
}



@end
