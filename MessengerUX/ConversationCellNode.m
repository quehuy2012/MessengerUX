//
//  ConversationCellNode.m
//  MessengerUX
//
//  Created by Dam Vu Duy on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ConversationCellNode.h"
#import "UXSentence.h"
#import "UXSentence+DummyComming.h"

@interface ConversationCellNode ()

@property (nonatomic) UXSentence * sentence;
@property (nonatomic) ASImageNode * avatarNode;
@property (nonatomic) ASTextNode * contentNode;
@property (nonatomic) ASDisplayNode * contentBackgroundNode;

@end

@implementation ConversationCellNode

- (instancetype)initWithSentence:(UXSentence *)sentence {
    self = [super init];
    if (self) {
        self.sentence = sentence;
        
        self.avatarNode = [[ASImageNode alloc] init];
        self.avatarNode.backgroundColor = [UIColor whiteColor];
        self.avatarNode.style.width = ASDimensionMakeWithPoints(34);
        self.avatarNode.style.height = ASDimensionMakeWithPoints(34);
        self.avatarNode.cornerRadius = 17;
        self.avatarNode.image = [UIImage imageNamed:@"cameraThumb"];
        self.avatarNode.clipsToBounds = YES;
        [self addSubnode:self.avatarNode];
        
        
        self.contentBackgroundNode = [[ASDisplayNode alloc] init];
        if (self.sentence.commingMessage) {
            self.contentBackgroundNode.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:147.0/255.0 blue:238.0/255.0 alpha:1.0];
        } else {
            self.contentBackgroundNode.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        }
        self.contentBackgroundNode.cornerRadius = 16;
        self.contentBackgroundNode.clipsToBounds = YES;
        [self addSubnode:self.contentBackgroundNode];
        
        
        self.contentNode = [[ASTextNode alloc] init];
        
        UIColor * textColor = [UIColor whiteColor];
        if (self.sentence.commingMessage) {
            textColor = [UIColor whiteColor];
        } else {
            textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
        }
        self.contentNode.attributedText = [[NSAttributedString alloc] initWithString:self.sentence.content
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                                                                                       NSForegroundColorAttributeName: textColor}];
        self.contentNode.style.flexShrink = 1.0;
        self.contentNode.truncationMode = NSLineBreakByTruncatingTail;
        self.contentNode.style.maxWidth = ASDimensionMake(240);
        [self addSubnode:self.contentNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASRelativeLayoutSpec * avatarSpec =
    [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionCenter
                                                          verticalPosition:ASRelativeLayoutSpecPositionEnd
                                                              sizingOption:ASRelativeLayoutSpecSizingOptionMinimumWidth
                                                                     child:self.avatarNode];
    
    ASInsetLayoutSpec * contentInsetsSpec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12, 12, 12, 12)
                                           child:self.contentNode];
    
    ASBackgroundLayoutSpec * backgroung =
    [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:contentInsetsSpec background:self.contentBackgroundNode];
    
    if (self.sentence.commingMessage) {
    
        ASStackLayoutSpec * contentStackSpec =
        [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                spacing:8
                                         justifyContent:ASStackLayoutJustifyContentStart
                                             alignItems:ASStackLayoutAlignItemsEnd
                                               children:@[avatarSpec, backgroung]];
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(16, 8, 16, 8)
                                                      child:contentStackSpec];
    } else {
        
        ASStackLayoutSpec * contentStackSpec =
        [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                spacing:8
                                         justifyContent:ASStackLayoutJustifyContentEnd
                                             alignItems:ASStackLayoutAlignItemsEnd
                                               children:@[backgroung, avatarSpec]];
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(16, 8, 16, 8)
                                                      child:contentStackSpec];
    }
}

@end
