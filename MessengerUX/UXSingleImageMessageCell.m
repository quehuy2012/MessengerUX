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
        self.imageDimentionRatio = image.size.height / image.size.width;
        self.imageContentNode.style.maxWidth = ASDimensionMake(240);
        self.imageContentNode.style.maxHeight = ASDimensionMake(240*self.imageDimentionRatio);
        self.imageContentNode.clipsToBounds = YES;
        ((ASImageNode *)self.imageContentNode).image = image;
        
        [self addSubnode:self.imageContentNode];
    }
    
    return self;
}

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImageURL:(NSURL *)imageURL ratio:(CGFloat)ratio {
    self = [self initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.imageContentNode = [[ASNetworkImageNode alloc] init];
        self.imageContentNode.cornerRadius = [configure getMessageBackgroundStyle].cornerRadius;
        self.imageDimentionRatio = ratio;
        self.imageContentNode.style.maxWidth = ASDimensionMake(240);
        self.imageContentNode.style.maxHeight = ASDimensionMake(240*ratio);
        self.imageContentNode.clipsToBounds = YES;
        ((ASNetworkImageNode *)self.imageContentNode).URL = imageURL;
        
        [self addSubnode:self.imageContentNode];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec * imageInset =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                           child:self.imageContentNode];
    
    NSMutableArray * stackedMessageChilds = [@[] mutableCopy];
    if (self.showTextAsTop) {
        ASInsetLayoutSpec * topTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, self.configure.insets.left*2, 0, self.configure.insets.right*2)
                                               child:self.topTextNode];
        [stackedMessageChilds addObject:topTextInset];
    }
    [stackedMessageChilds addObject:imageInset];
    if (self.showTextAsBottom) {
        ASInsetLayoutSpec * bottomTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, self.configure.insets.left*2, 0, self.configure.insets.right*2)
                                               child:self.bottomTextNode];
        [stackedMessageChilds addObject:bottomTextInset];
    }
    
    ASStackLayoutAlignItems supportAlignItem = ASStackLayoutAlignItemsStart;
    if (!self.isIncomming) {
        supportAlignItem = ASStackLayoutAlignItemsEnd;
    }
    
    ASStackLayoutSpec * stackedMessage =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                            spacing:0
                                     justifyContent:ASStackLayoutJustifyContentCenter
                                         alignItems:supportAlignItem
                                           children:stackedMessageChilds];
    
    NSArray * mainChilds = nil;
    ASStackLayoutJustifyContent mainLayoutJustify = ASStackLayoutJustifyContentStart;
    if (self.isIncomming) {
        mainChilds = @[self.avatarNode, stackedMessage];
    } else {
        mainChilds = @[stackedMessage, self.avatarNode];
        mainLayoutJustify = ASStackLayoutJustifyContentEnd;
    }
    
    ASStackLayoutSpec * mainContent =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:8
                                     justifyContent:mainLayoutJustify
                                         alignItems:ASStackLayoutAlignItemsEnd
                                           children:mainChilds];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:self.configure.insets child:mainContent];
}


@end
