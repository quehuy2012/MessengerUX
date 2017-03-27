//
//  UXMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell.h"

#import "UXMessageCellConfigure.h"
#import "UXMessageBackgroundStyle.h"
#import "UXSpeaker.h"

//@interface UXMessageCell ()
//
//@property (nonatomic) ASTextNode * topTextNode;
//@property (nonatomic) ASTextNode * bottomTextNode;
//@property (nonatomic) ASImageNode * avatarNode;
//@property (nonatomic) ASDisplayNode * messageBackgroundNode;
//
//@end

@implementation UXMessageCell

@synthesize showTextAsTop = _showTextAsTop;
@synthesize showTextAsBottom = _showTextAsBottom;

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
//        self.avatarNode.image = self.owner ? self.owner.avatar : [UIImage imageNamed:@"cameraThumb"]; // TODO set default thumbnail
        self.avatarNode.image = [UIImage imageNamed:@"cameraThumb"];
        self.avatarNode.clipsToBounds = YES;
        [self addSubnode:self.avatarNode];
        
        self.topTextNode = [[ASTextNode alloc] init];
        self.topTextNode.backgroundColor = [UIColor clearColor];
        self.topTextNode.style.flexShrink = 1.0;
        self.topTextNode.truncationMode = NSLineBreakByTruncatingTail;
        self.topTextNode.style.maxWidth = ASDimensionMake(240);
        [self addSubnode:self.topTextNode];
        
        self.bottomTextNode = [[ASTextNode alloc] init];
        self.bottomTextNode.backgroundColor = [UIColor clearColor];
        self.bottomTextNode.style.flexShrink = 1.0;
        self.bottomTextNode.truncationMode = NSLineBreakByTruncatingTail;
        self.bottomTextNode.style.maxWidth = ASDimensionMake(240);
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
            [self addSubnode:self.messageBackgroundNode];
        }
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSAssert(NO, @"Need override this method");
    return nil;
}

- (void)setTopText:(NSString *)string {
    if (string) {
        self.topTextNode.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.configure.supportTextSize],
                                                                                       NSForegroundColorAttributeName: self.configure.supportTextColor}];
        [self setShowTextAsTop:YES];
    }
}

- (void)setBottomText:(NSString *)string {
    if (string) {
        self.bottomTextNode.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.configure.supportTextSize],
                                                                                       NSForegroundColorAttributeName: self.configure.supportTextColor}];
        [self setShowTextAsBottom:YES];
    }
}

- (void)setShowTextAsTop:(BOOL)flagShowTextAsTop {
    _showTextAsTop = flagShowTextAsTop;
    [self setNeedsLayout];
}

- (void)setShowTextAsBottom:(BOOL)flagShowTextAsBottom {
    _showTextAsBottom = flagShowTextAsBottom;
    [self setNeedsLayout];
}

@end
