//
//  UXAttributeMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 4/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAttributeMessageCell.h"
#import "UXMessageCellConfigure.h"
#import "UXAttributeNode.h"
#import "UXAttributeMessage.h"

@interface UXAttributeMessageCell ()

@property (nonatomic) UXAttributeNode * messageNode;

@end

@implementation UXAttributeMessageCell

@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.messageNode = [[UXAttributeNode alloc] init];
        self.messageNode.style.maxWidth = ASDimensionMake([UXMessageCellConfigure getGlobalConfigure].maxWidthOfCell);
        self.messageNode.backgroundColor = [UIColor clearColor];
        [self.messageNode addTarget:self action:@selector(messageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.messageNode addTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
        [self.messageNode addTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
        [self addSubnode:self.messageNode];
        
    }
    
    return self;
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    [super shouldUpdateCellNodeWithObject:object];
    if ([object isKindOfClass:[UXAttributeMessage class]]) {
        UXAttributeMessage * textMessage = object;
        
        UIColor * textColor = self.isIncomming ? [UXMessageCellConfigure getGlobalConfigure].incommingTextColor : [UXMessageCellConfigure getGlobalConfigure].outgoingTextColor;
        
        NIHTMLParser * htmlParser = [[NIHTMLParser alloc] initWithString:textMessage.content parseEmoticon:YES];
        [htmlParser setDefaultTextColor:textColor];
        [htmlParser setFontText:[UIFont systemFontOfSize:[UXMessageCellConfigure getGlobalConfigure].contentTextSize]];
        [htmlParser setLinkFont:[UIFont systemFontOfSize:[UXMessageCellConfigure getGlobalConfigure].contentTextSize]];
        
        self.messageNode.htmlParser = htmlParser;
        [self.messageNode setLinkHighlightColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [self.messageNode setBackgroundColor:[UIColor clearColor]];
        
        
        [self setTopText:textMessage.owner.name];
        
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:textMessage.time];
        NSDateFormatter *dfTime = [NSDateFormatter new];
        [dfTime setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        NSString * time = [dfTime stringFromDate:date];
        
        [self setBottomText:time];
        
        [self setShowTextAsBottom:NO];
        [self setShowTextAsTop:NO];
    }
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec * messageInsetsSpec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12, 12, 12, 12)
                                           child:self.messageNode];
    
    ASBackgroundLayoutSpec * messageBubble =
    [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:messageInsetsSpec
                                               background:self.messageBackgroundNode];
    
    NSArray * mainChild = nil;
    if (self.showSubFunction) {
        if (self.isIncomming) {
            mainChild = @[messageBubble, self.subFuntionNode];
        } else {
            mainChild = @[self.subFuntionNode, messageBubble];
        }
    } else {
        mainChild = @[messageBubble];
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
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, [UXMessageCellConfigure getGlobalConfigure].insets.left*2, 0, [UXMessageCellConfigure getGlobalConfigure].insets.right*2) child:self.topTextNode];
        
        [stackedMessageChilds addObject:topTextInset];
    }
    
    [stackedMessageChilds addObject:mainWithSubFunctionStack];
    
    if (self.showTextAsBottom) {
        ASInsetLayoutSpec * bottomTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, [UXMessageCellConfigure getGlobalConfigure].insets.left*2, 0, [UXMessageCellConfigure getGlobalConfigure].insets.right*2) child:self.bottomTextNode];
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
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:[UXMessageCellConfigure getGlobalConfigure].insets
                                                  child:mainContent];
}

#pragma mark - Action

- (void)messageClicked:(ASTextNode *)messageNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:messageClicked:)]) {
        [self.delegate messageCell:self messageClicked:messageNode];
    }
    
    [self setShowTextAsTop:!self.showTextAsTop];
    [self setShowTextAsBottom:!self.showTextAsBottom];
    
    [self setNeedsLayout];
}

- (void)beginHighlight {
    [self setHighlighted:YES];
}

- (void)endHighlight {
    [self setHighlighted:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    //    [super setHighlighted:highlighted];
    
    if (highlighted) {
        if (self.messageBackgroundNode) {
            self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].highlightBackgroundColor;
        }
        self.messageNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].highlightBackgroundColor;
        
    } else {
        if (self.messageBackgroundNode) {
            if (self.isIncomming) {
                self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].incommingColor;
                self.messageNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].incommingColor;
            } else {
                self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].outgoingColor;
                self.messageNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].outgoingColor;
            }
        }
    }
}

#pragma mark - Memory managment

- (void)clearContents {
    [super clearContents];
    
    [self.messageNode clearContents];
    [self clearLayerContentOfLayer:self.messageNode.layer];
    
}


@end
