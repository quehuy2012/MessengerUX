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
#import "UXOwner.h"

#import "UXImageMessage.h"

@interface UXSingleImageMessageCell ()

@property (nonatomic) ASDisplayNode * imageContentNode;
@property (nonatomic) CGFloat imageDimentionRatio;
@property (nonatomic) NSUInteger imagePadding;

@end

@implementation UXSingleImageMessageCell

@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imagePadding = 4;
    }
    
    return self;
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    [super shouldUpdateCellNodeWithObject:object];
    if ([object isKindOfClass:[UXImageMessage class]]) {
        UXImageMessage * imageMessage = object;
        
        if (imageMessage.image) {
            self.imageContentNode = [[ASImageNode alloc] init];
            ((ASImageNode *)self.imageContentNode).image = imageMessage.image;
            
            [((ASImageNode *)self.imageContentNode) addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
            [((ASImageNode *)self.imageContentNode) addTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
            [((ASImageNode *)self.imageContentNode) addTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
            
            [self addSubnode:self.imageContentNode];
        } else {
            self.imageContentNode = [[ASNetworkImageNode alloc] init];
            ((ASNetworkImageNode *)self.imageContentNode).URL = imageMessage.imageURL;
            
            [((ASNetworkImageNode *)self.imageContentNode) addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
            [((ASNetworkImageNode *)self.imageContentNode) addTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
            [((ASNetworkImageNode *)self.imageContentNode) addTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
            
            [self addSubnode:self.imageContentNode];
        }
        
        self.imageContentNode.cornerRadius = [self.configure getMessageBackgroundStyle].cornerRadius - self.imagePadding;
        self.imageDimentionRatio = imageMessage.image != nil ? imageMessage.image.size.height / imageMessage.image.size.width : imageMessage.ratio;
        self.imageContentNode.style.maxWidth = ASDimensionMake(self.configure.maxWidthOfCell);
        self.imageContentNode.style.maxHeight = ASDimensionMake(self.configure.maxWidthOfCell*self.imageDimentionRatio);
        self.imageContentNode.clipsToBounds = YES;
        self.imageContentNode.layerBacked = YES;
        
        [self setShowSubFunction:YES];
    }
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
                                            spacing:4
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

#pragma mark - Memory managment

- (void)clearContents {
    [super clearContents];
    
    [self.imageContentNode clearContents];
    self.imageContentNode.layer.contents = nil;
}

@end
