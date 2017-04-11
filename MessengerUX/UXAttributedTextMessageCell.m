//
//  UXAttributedTextMessageCell.m
//  MessengerUX
//
//  Created by CPU11808 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAttributedTextMessageCell.h"
#import "UXAttributedTextNode.h"
#import "UXMessageCellConfigure.h"
#import "UXOwner.h"
#import "UXAttributedTextMessage.h"

@interface UXAttributedTextMessageCell()

@property(nonatomic) UXAttributedTextNode *textNode;

@end

@implementation UXAttributedTextMessageCell

-(instancetype)init {
    if (self = [super init]) {
        self.textNode = [[UXAttributedTextNode alloc] init];
        self.textNode.font = [UIFont systemFontOfSize:self.configure.contentTextSize];
        self.textNode.style.maxWidth = ASDimensionMake(self.configure.maxWidthOfCell);
        self.textNode.linkColor = [UIColor redColor];
        self.textNode.linkFont = [UIFont systemFontOfSize:20];
        self.textNode.tagColor = [UIColor yellowColor];
        self.textNode.tagFont = [UIFont systemFontOfSize:20];
        [self addSubnode:self.textNode];
    }
    return self;
}

-(void)shouldUpdateCellNodeWithObject:(id)object {
    [super shouldUpdateCellNodeWithObject:object];
    if ([object isKindOfClass:[UXAttributedTextMessage class]]) {
        UXAttributedTextMessage *message = object;
        
        self.textNode.textColor = self.isIncomming ? self.configure.incommingTextColor : self.configure.outgoingTextColor;
        [self.textNode setText:message.content];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec * messageInsetsSpec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12, 12, 12, 12)
                                           child:self.textNode];
    
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

@end
