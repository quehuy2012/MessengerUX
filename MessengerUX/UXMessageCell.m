//
//  UXMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell.h"
#import "UXMessageCell+Private.h"

#import "UXMessageCellConfigure.h"
#import "UXMessageBackgroundStyle.h"
#import "UXSpeaker.h"

@implementation UXMessageCell

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner {
    self = [super init];
    if (self) {
        
        self.configure = configure;
        self.owner = owner;
        self.isIncomming = incomming;
        
        self.avatarNode = [[ASImageNode alloc] init];
        self.avatarNode.backgroundColor = [UIColor whiteColor];
        self.avatarNode.style.width = ASDimensionMakeWithPoints(34);
        self.avatarNode.style.height = ASDimensionMakeWithPoints(34);
        self.avatarNode.cornerRadius = 17;
        self.avatarNode.image = self.owner ? self.owner.avatar : [UIImage imageNamed:@"cameraThumb"]; // TODO set default thumbnail
        self.avatarNode.clipsToBounds = YES;
        [self addSubnode:self.avatarNode];
        
        self.topTextNode = [[ASTextNode alloc] init];
        self.topTextNode.backgroundColor = [UIColor whiteColor];
        [self addSubnode:self.topTextNode];
        
        self.bottomTextNode = [[ASTextNode alloc] init];
        self.bottomTextNode.backgroundColor = [UIColor whiteColor];
        [self addSubnode:self.bottomTextNode];
        
        if (self.configure) {
            self.messageBackgroundNode = [[self.configure getMessageBackgroundStyle] getMessageBackground];
            if (self.messageBackgroundNode) {
                if (self.isIncomming) {
                    self.messageBackgroundNode.backgroundColor = self.configure.incommingColor;
                } else {
                    self.messageBackgroundNode.backgroundColor = self.configure.outgoingColor;
                }
            }
        }
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSAssert(NO, @"Need override this method");
    return nil;
}

- (void)setTopText:(NSString *)string {
    self.topTextNode.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.configure.supportTextSize],
                                                                                   NSForegroundColorAttributeName: self.configure.supportTextColor}];
}

- (void)setBottomText:(NSString *)string {
    self.bottomTextNode.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.configure.supportTextSize],
                                                                                   NSForegroundColorAttributeName: self.configure.supportTextColor}];
}

- (void)showTopText:(BOOL)flag {
    self.topTextNode.hidden = !flag;
}

- (void)showBottomText:(BOOL)flag {
    self.bottomTextNode.hidden = !flag;
}

@end
