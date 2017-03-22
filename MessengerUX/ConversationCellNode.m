//
//  ConversationCellNode.m
//  MessengerUX
//
//  Created by Dam Vu Duy on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ConversationCellNode.h"
#import "Sentence.h"

@interface ConversationCellNode ()

@property (nonatomic) Sentence * sentence;
@property (nonatomic) ASImageNode * avatarNode;
@property (nonatomic) ASTextNode * contentNode;

@end

@implementation ConversationCellNode

- (instancetype)initWithSentence:(Sentence *)sentence {
    self = [super init];
    if (self) {
        self.sentence = sentence;
        
        self.avatarNode = [[ASImageNode alloc] init];
        self.avatarNode.backgroundColor = [UIColor whiteColor];
        self.avatarNode.style.width = ASDimensionMakeWithPoints(24);
        self.avatarNode.style.height = ASDimensionMakeWithPoints(24);
        self.avatarNode.cornerRadius = 12;
        self.avatarNode.image = [UIImage imageNamed:@"cameraThumb"];
        [self addSubnode:self.avatarNode];
        
        self.contentNode = [[ASTextNode alloc] init];
        self.contentNode.attributedText = [[NSAttributedString alloc] initWithString:self.sentence.content
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                                                                       NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.contentNode.style.flexShrink = 1.0;
        self.contentNode.truncationMode = NSLineBreakByTruncatingTail;
        self.contentNode.style.maxWidth = ASDimensionMake(240);
        [self addSubnode:self.contentNode];
    }
    return self;
}

- (ASLayout *)layoutThatFits:(ASSizeRange)constrainedSize {
    ASRelativeLayoutSpec * avatarSpec =
    [[ASRelativeLayoutSpec alloc] initWithHorizontalPosition:ASRelativeLayoutSpecPositionCenter
                                            verticalPosition:ASRelativeLayoutSpecPositionEnd
                                                sizingOption:ASRelativeLayoutSpecSizingOptionMinimumWidth
                                                       child:self.avatarNode];
    
    ASInsetLayoutSpec * avatarInsetsSpec =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 8, 8, 8) child:avatarSpec];
    
    return avatarInsetsSpec;
}

@end
