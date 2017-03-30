//
//  UXTextMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXTextMessageCell.h"

#import "UXMessageCellConfigure.h"
#import "UXSpeaker.h"

@interface UXTextMessageCell ()

@property (nonatomic) ASTextNode * messageNode;

@end

@implementation UXTextMessageCell

@synthesize delegate;

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentText:(NSString *)string {
    self = [super initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        
        UIColor * textColor = self.isIncomming ? self.configure.incommingTextColor : self.configure.outgoingTextColor;
        
        self.messageNode = [[ASTextNode alloc] init];
        self.messageNode.style.flexShrink = 1.0;
        self.messageNode.truncationMode = NSLineBreakByTruncatingTail;
        self.messageNode.style.maxWidth = ASDimensionMake(configure.maxWidthOfCell);
        self.messageNode.backgroundColor = [UIColor clearColor];
        self.messageNode.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.configure.contentTextSize],
                                                                                       NSForegroundColorAttributeName: textColor}];
        [self.messageNode addTarget:self action:@selector(messageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.messageNode addTarget:self action:@selector(beginHighlight) forControlEvents:ASControlNodeEventTouchDown];
        [self.messageNode addTarget:self action:@selector(endHighlight) forControlEvents:ASControlNodeEventTouchDragOutside|ASControlNodeEventTouchUpInside|ASControlNodeEventTouchUpOutside|ASControlNodeEventTouchCancel];
        [self addSubnode:self.messageNode];
        
    }
    
    return self;
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
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, self.configure.insets.left*2, 0, self.configure.insets.right*2) child:self.topTextNode];
        
        [stackedMessageChilds addObject:topTextInset];
    }
    
    [stackedMessageChilds addObject:mainWithSubFunctionStack];
    
    if (self.showTextAsBottom) {
        ASInsetLayoutSpec * bottomTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, self.configure.insets.left*2, 0, self.configure.insets.right*2) child:self.bottomTextNode];
        [stackedMessageChilds addObject:bottomTextInset];
    }
    
    ASStackLayoutAlignItems supportAlignItem = ASStackLayoutAlignItemsStart;
    if (!self.isIncomming) {
        supportAlignItem = ASStackLayoutAlignItemsEnd;
    }
    
    ASStackLayoutSpec * stackedMessage =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                            spacing:2
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
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:self.configure.insets
                                                  child:mainContent];
}

#pragma mark - Action

- (void)messageClicked:(ASTextNode *)messageNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:messageClicked:)]) {
        [self.delegate messageCell:self messageClicked:messageNode];
    }
}

- (void)beginHighlight {
    [self setHighlighted:YES];
}

- (void)endHighlight {
    [self setHighlighted:NO];
}

@end
