//
//  UXTitleMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXTitleMessageCell.h"
#import "UXMessageCellConfigure.h"

@interface UXTitleMessageCell ()

@property (nonatomic) ASTextNode * titleNode;

@end

@implementation UXTitleMessageCell

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure title:(NSString *)title {
    self = [self initWithConfigure:configure isIncomming:NO andOwner:nil];
    if (self) {
        
        self.titleNode = [[ASTextNode alloc] init];
        self.titleNode.style.flexShrink = 1.0;
        self.titleNode.truncationMode = NSLineBreakByTruncatingTail;
        self.titleNode.style.maxWidth = ASDimensionMake(240);
        self.titleNode.backgroundColor = [UIColor clearColor];
        self.titleNode.attributedText = [[NSAttributedString alloc] initWithString:[title uppercaseString]
                                                                          attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:self.configure.supportTextSize + 2],
                                                                                       NSForegroundColorAttributeName: self.configure.supportTextColor}];
        [self addSubnode:self.titleNode];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec * alignStack =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:0
                                     justifyContent:ASStackLayoutJustifyContentCenter
                                         alignItems:ASStackLayoutAlignItemsCenter
                                           children:@[self.titleNode]];
    
    UIEdgeInsets normalInset = self.configure.insets;
    CGFloat factor = 1.5;
    UIEdgeInsets insets =  UIEdgeInsetsMake(normalInset.top*1.3, 0, normalInset.bottom*factor, 0);
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:alignStack];
}

@end
