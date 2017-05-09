//
//  UXTitleMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell+Private.h"
#import "UXTitleMessageCell.h"
#import "UXMessageCellConfigure.h"
#import "UXTitleMessage.h"

@interface UXTitleMessageCell ()

@property (nonatomic) ASTextNode * titleNode;

@end

@implementation UXTitleMessageCell

@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self initView];
    }
    
    return self;
}

- (void)initView {
    
    if (self.viewRemoved) {
        [super initView];
        
        self.titleNode = [[ASTextNode alloc] init];
        self.titleNode.style.flexShrink = 1.0;
        self.titleNode.truncationMode = NSLineBreakByTruncatingTail;
        self.titleNode.style.maxWidth = ASDimensionMake([UXMessageCellConfigure getGlobalConfigure].maxWidthOfCell);
        self.titleNode.backgroundColor = [UIColor clearColor];
        self.titleNode.maximumNumberOfLines = 1;
        
        [self.titleNode addTarget:self action:@selector(titleClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.titleNode addTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
        [self.titleNode addTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
        
        [self addSubnode:self.titleNode];
        
        self.viewRemoved = NO;
    }
}

- (void)clearView {
    
    if (!self.viewRemoved) {
        [super clearView];
        
        [self.titleNode removeFromSupernode];
        
        [self.titleNode removeTarget:self action:@selector(titleClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.titleNode removeTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
        [self.titleNode removeTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
        
        [self.titleNode clearContents];
        [self clearLayerContentOfLayer:self.titleNode.layer];
        
        self.titleNode = nil;
        
        self.viewRemoved = YES;
    }
}

- (void)updateUI:(id)model {
    if (model && !self.viewRemoved) {
        [super updateUI:model];
        
        if ([model isKindOfClass:[UXTitleMessage class]]) {
            UXTitleMessage * titleMessage = model;
            self.titleNode.attributedText = [[NSAttributedString alloc] initWithString:[titleMessage.title uppercaseString]
                                                                            attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:[UXMessageCellConfigure getGlobalConfigure].supportTextSize + 2],
                                                                                         NSForegroundColorAttributeName: [UXMessageCellConfigure getGlobalConfigure].supportTextColor}];
        }
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    if (self.viewRemoved) {
        if (self.tempHolder == nil) {
            self.tempHolder = [[ASDisplayNode alloc] init];
        }
        self.tempHolder.style.width = ASDimensionMake(self.calculatedSize.width);
        self.tempHolder.style.height = ASDimensionMake(self.calculatedSize.height);
        return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                       spacing:0
                                                justifyContent:ASStackLayoutJustifyContentStart
                                                    alignItems:ASStackLayoutAlignItemsEnd
                                                      children:@[self.tempHolder]];
    } else {
        
//        self.tempHolder = nil;
        
        ASStackLayoutSpec * alignStack =
        [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                spacing:0
                                         justifyContent:ASStackLayoutJustifyContentCenter
                                             alignItems:ASStackLayoutAlignItemsCenter
                                               children:@[self.titleNode]];
        
        UIEdgeInsets normalInset = [UXMessageCellConfigure getGlobalConfigure].insets;
        CGFloat factor = 1.5;
        UIEdgeInsets insets =  UIEdgeInsetsMake(normalInset.top*1.3, 0, normalInset.bottom*factor, 0);
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:alignStack];
    }
}

- (CGRect)editableFrame {
    if (self.titleNode) {
        return self.titleNode.frame;
    } else {
        return CGRectZero;
    }
}

#pragma mark - Action

- (void)titleClicked:(ASTextNode *)titleNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:titleClicked:)]) {
        [self.delegate messageCell:self titleClicked:titleNode];
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
    
    [self.titleNode clearContents];
    [self clearLayerContentOfLayer:self.titleNode.layer];
}

- (void)dealloc {
//    [self clearContents];
    [self clearView];
}

@end
