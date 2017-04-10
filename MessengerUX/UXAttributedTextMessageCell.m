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

//- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentText:(NSString *)string {
//    
//    self = [super initWithConfigure:configure isIncomming:incomming andOwner:owner];
//    
//    if (self) {
//        
//        UIColor *textColor = self.isIncomming ? self.configure.incommingTextColor : self.configure.outgoingTextColor;
//        
//        self.textNode = [[UXAttributedTextNode alloc] initWithText:string];
//        self.textNode.style.maxWidth = ASDimensionMake(configure.maxWidthOfCell);
//        self.textNode.textColor = textColor;
//        self.textNode.font = [UIFont systemFontOfSize:self.configure.contentTextSize];
//        
//        // test set alignment
////        self.textNode.textAlignment = kCTTextAlignmentRight;
//        
////        self.textNode.linkHighlightColor = [UIColor yellowColor];
//
//        [self addSubnode:self.textNode];
//    }
//    
//    return self;
//}

-(instancetype)init {
    if (self = [super init]) {
        self.textNode = [[UXAttributedTextNode alloc] init];
        self.textNode.textColor = [UIColor blackColor];
        self.textNode.font = [UIFont systemFontOfSize:16];
        self.textNode.style.maxWidth = ASDimensionMake(self.configure.maxWidthOfCell);
        [self addSubnode:self.textNode];
    }
    return self;
}

-(void)shouldUpdateCellNodeWithObject:(id)object {
    [super shouldUpdateCellNodeWithObject:object];
    if ([object isKindOfClass:[UXAttributedTextMessage class]]) {
        UXAttributedTextMessage *message = object;
        
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
