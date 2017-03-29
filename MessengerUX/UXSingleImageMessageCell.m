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
@property (nonatomic) NSUInteger imagePadding;

@end

@implementation UXSingleImageMessageCell

@synthesize delegate;

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner {
    self = [super initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.imagePadding = 4;
    }
    
    return self;
}

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImage:(UIImage *)image {
    self = [self initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.imageContentNode = [[ASImageNode alloc] init];
        self.imageContentNode.cornerRadius = [configure getMessageBackgroundStyle].cornerRadius - self.imagePadding;
        self.imageDimentionRatio = image.size.height / image.size.width;
        self.imageContentNode.style.maxWidth = ASDimensionMake(configure.maxWidthOfCell);
        self.imageContentNode.style.maxHeight = ASDimensionMake(configure.maxWidthOfCell*self.imageDimentionRatio);
        self.imageContentNode.clipsToBounds = YES;
        ((ASImageNode *)self.imageContentNode).image = image;
        
        [((ASImageNode *)self.imageContentNode) addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [((ASImageNode *)self.imageContentNode) addTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
        [((ASImageNode *)self.imageContentNode) addTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
        
        [self addSubnode:self.imageContentNode];
    }
    
    return self;
}

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImageURL:(NSURL *)imageURL ratio:(CGFloat)ratio {
    self = [self initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.imageContentNode = [[ASNetworkImageNode alloc] init];
        self.imageContentNode.cornerRadius = [configure getMessageBackgroundStyle].cornerRadius - self.imagePadding;
        self.imageDimentionRatio = ratio;
        self.imageContentNode.style.maxWidth = ASDimensionMake(configure.maxWidthOfCell);
        self.imageContentNode.style.maxHeight = ASDimensionMake(configure.maxWidthOfCell*ratio);
        self.imageContentNode.clipsToBounds = YES;
        ((ASNetworkImageNode *)self.imageContentNode).URL = imageURL;
        
        [((ASNetworkImageNode *)self.imageContentNode) addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [((ASNetworkImageNode *)self.imageContentNode) addTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
        [((ASNetworkImageNode *)self.imageContentNode) addTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
        
        [self addSubnode:self.imageContentNode];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec * imageInset =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.imagePadding, self.imagePadding, self.imagePadding, self.imagePadding)
                                           child:self.imageContentNode];
    
    ASBackgroundLayoutSpec * imageWithBackground =
    [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:imageInset background:self.messageBackgroundNode];
    
    NSArray * mainChild = nil;
    if (self.showSubFunction) {
        if (self.isIncomming) {
            mainChild = @[imageWithBackground, self.subFuntionNode];
        } else {
            mainChild = @[self.subFuntionNode, imageWithBackground];
        }
    } else {
        mainChild = @[imageWithBackground];
    }
    
    ASStackLayoutSpec * mainWithSubFunctionStack =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:16
                                     justifyContent:ASStackLayoutJustifyContentCenter
                                         alignItems:ASStackLayoutAlignItemsCenter
                                           children:mainChild];
    
    
    NSMutableArray * stackedMessageChilds = [@[] mutableCopy];
    
    if (self.showTextAsTop) {
        ASInsetLayoutSpec * topTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, self.configure.insets.left*2, 0, self.configure.insets.right*2)
                                               child:self.topTextNode];
        [stackedMessageChilds addObject:topTextInset];
    }
    
    [stackedMessageChilds addObject:mainWithSubFunctionStack];
    
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

- (CGRect)editableFrame {
    if (self.imageContentNode) {
        return self.imageContentNode.frame;
    } else {
        return CGRectZero;
    }
}

#pragma mark - Action

- (void) imageClicked:(ASControlNode *)imageNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:imageClicked:)]) {
        [self.delegate messageCell:self imageClicked:imageNode];
    }
}

- (void)beginHighlight {
    [self setHighlighted:YES];
}

- (void)endHighlight {
    [self setHighlighted:NO];
}

@end
