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
#import "UXOwner.h"
#import "UXMessage.h"
//@interface UXMessageCell ()
//
//@property (nonatomic) ASTextNode * topTextNode;
//@property (nonatomic) ASTextNode * bottomTextNode;
//@property (nonatomic) ASImageNode * avatarNode;
//@property (nonatomic) ASDisplayNode * messageBackgroundNode;
//
//@end

@interface UXMessageCell () {
    int mID;
    int trackID;
}

@end

@implementation UXMessageCell

@synthesize showTextAsTop = _showTextAsTop;
@synthesize showTextAsBottom = _showTextAsBottom;
@synthesize showSubFunction = _showSubFunction;

- (instancetype)init {
    self = [super init];
    
    static int ID = 0;
    
    if (self) {
        
        mID = ID++;
        trackID = -1;
        
        self.isIncomming = NO;
        
        self.viewRemoved = YES;
        self.firstInited = YES;
    }
    
    return self;
}

- (void)initView {
    
    if (self.viewRemoved) {
        self.avatarNode = [[ASImageNode alloc] init];
        self.avatarNode.backgroundColor = [UIColor whiteColor];
        self.avatarNode.style.width = ASDimensionMakeWithPoints(34);
        self.avatarNode.style.height = ASDimensionMakeWithPoints(34);
        self.avatarNode.cornerRadius = 17;
        self.avatarNode.clipsToBounds = YES;
        [self.avatarNode addTarget:self action:@selector(avatarClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:self.avatarNode];
        
        self.topTextNode = [[ASTextNode alloc] init];
        self.topTextNode.backgroundColor = [UIColor clearColor];
        self.topTextNode.style.flexShrink = 1.0;
        self.topTextNode.truncationMode = NSLineBreakByTruncatingTail;
        self.topTextNode.style.maxWidth = ASDimensionMake(240);
        [self.topTextNode addTarget:self action:@selector(supportTextClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:self.topTextNode];
        
        self.bottomTextNode = [[ASTextNode alloc] init];
        self.bottomTextNode.backgroundColor = [UIColor clearColor];
        self.bottomTextNode.style.flexShrink = 1.0;
        self.bottomTextNode.truncationMode = NSLineBreakByTruncatingTail;
        self.bottomTextNode.style.maxWidth = ASDimensionMake(240);
        [self.bottomTextNode addTarget:self action:@selector(supportTextClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:self.bottomTextNode];
        
        self.subFuntionNode = [[ASImageNode alloc] init];
        self.subFuntionNode.backgroundColor = [UIColor clearColor];
        self.subFuntionNode.style.width = ASDimensionMakeWithPoints(26);
        self.subFuntionNode.style.height = ASDimensionMakeWithPoints(26);
        self.subFuntionNode.image = [UIImage imageNamed:@"subFunctionIcon"];
        self.subFuntionNode.clipsToBounds = YES;
        [self.subFuntionNode addTarget:self action:@selector(subFunctionClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:self.subFuntionNode];
        
        if ([UXMessageCellConfigure getGlobalConfigure]) {
            self.messageBackgroundNode = [[[UXMessageCellConfigure getGlobalConfigure] getMessageBackgroundStyle] getMessageBackground];
            [self addSubnode:self.messageBackgroundNode];
        }
        
        self.viewRemoved = NO;
    }
}

- (void)clearView {
    
    if (!self.viewRemoved) {
        
        [self.avatarNode removeTarget:self action:@selector(avatarClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.avatarNode removeFromSupernode];
        self.avatarNode = nil;
        
        [self.topTextNode removeTarget:self action:@selector(supportTextClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.topTextNode removeFromSupernode];
        self.topTextNode = nil;
        
        [self.bottomTextNode removeTarget:self action:@selector(supportTextClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.bottomTextNode removeFromSupernode];
        self.bottomTextNode = nil;
        
        [self.subFuntionNode removeTarget:self action:@selector(subFunctionClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self.subFuntionNode removeFromSupernode];
        self.subFuntionNode = nil;
        
        [self.messageBackgroundNode removeFromSupernode];
        self.messageBackgroundNode = nil;
        
        self.viewRemoved = YES;
    }
}

- (void)updateUI:(id)model {
    if (model && !self.viewRemoved) {
        UXMessage * message = self.model;
        self.owner = message.owner;
        self.isIncomming = message.commingMessage;
        self.avatarNode.image = self.owner ? self.owner.avatar : [UIImage imageNamed:@"cameraThumb"]; // TODO set default thumbnail
        
        if (self.messageBackgroundNode) {
            
            if (self.isIncomming) {
                self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].incommingColor;
            } else {
                self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].outgoingColor;
            }
        }
    }
}

- (void)didEnterPreloadState {
    
    [self initView];
    
    [self updateUI:self.model];
    
    [self setNeedsLayout];
    
    [super didEnterPreloadState];
    
    if (mID == trackID) NSLog(@"%d enter", mID);
}

- (void)didExitPreloadState {
    [super didExitPreloadState];
    
    // remove all child view
    [self clearView];
    
    if (mID == trackID) NSLog(@"%d exit", mID);
}

- (void)didEnterDisplayState {
    [super didEnterDisplayState];
    if (mID == trackID) NSLog(@"%d display", mID);
}

- (void)didExitDisplayState {
    [super didExitDisplayState];
    if (mID == trackID) NSLog(@"%d dedisplay", mID);
}

- (void)didEnterVisibleState {
    [super didEnterVisibleState];
    if (mID == trackID) NSLog(@"%d visible", mID);
}

- (void)didExitVisibleState {
    [super didExitVisibleState];
    if (mID == trackID) NSLog(@"%d devisible", mID);
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    // parent do thing like setup general info
    if ([object isKindOfClass:[UXMessage class]]) {
        self.model = object;
        [self updateUI:self.model];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSAssert(NO, @"Need override method layoutSpecThatFits");
    return nil;
}

- (void)setTopText:(NSString *)string {
    if (string) {
        self.topTextNode.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UXMessageCellConfigure getGlobalConfigure].supportTextSize],
                                                                                       NSForegroundColorAttributeName: [UXMessageCellConfigure getGlobalConfigure].supportTextColor}];
        [self setShowTextAsTop:YES];
    }
}

- (void)setBottomText:(NSString *)string {
    if (string) {
        self.bottomTextNode.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UXMessageCellConfigure getGlobalConfigure].supportTextSize],
                                                                                       NSForegroundColorAttributeName: [UXMessageCellConfigure getGlobalConfigure].supportTextColor}];
        [self setShowTextAsBottom:YES];
    }
}

- (void)setShowTextAsTop:(BOOL)flagShowTextAsTop {
    _showTextAsTop = flagShowTextAsTop;
    self.topTextNode.hidden = !flagShowTextAsTop;
    [self setNeedsLayout];
}

- (void)setShowTextAsBottom:(BOOL)flagShowTextAsBottom {
    _showTextAsBottom = flagShowTextAsBottom;
    self.bottomTextNode.hidden = !flagShowTextAsBottom;
    [self setNeedsLayout];
}

- (void)setShowSubFunction:(BOOL)flagShowSubFunction {
    _showSubFunction = flagShowSubFunction;
    self.subFuntionNode.hidden = !flagShowSubFunction;
    [self setNeedsLayout];
}

- (CGRect)editableFrame {
    if (self.messageBackgroundNode) {
        return self.messageBackgroundNode.frame;
    } else {
        return CGRectZero;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        if (self.messageBackgroundNode) {
            self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].highlightBackgroundColor;
        }
    } else {
        if (self.messageBackgroundNode) {
            if (self.isIncomming) {
                self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].incommingColor;
            } else {
                self.messageBackgroundNode.backgroundColor = [UXMessageCellConfigure getGlobalConfigure].outgoingColor;
            }
        }
    }
}

#pragma mark - Action

- (void)avatarClicked:(ASImageNode *)avatarNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:avatarClicked:)]) {
        [self.delegate messageCell:self avatarClicked:avatarNode];
    }
}

- (void)supportTextClicked:(ASTextNode *)supportNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:supportLabelClicked:isTopLabel:)]) {
        [self.delegate messageCell:self supportLabelClicked:supportNode isTopLabel:(self.topTextNode == supportNode)];
    }
}

- (void)subFunctionClicked:(ASImageNode *)subFuntionNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:subFunctionClicked:)]) {
        [self.delegate messageCell:self subFunctionClicked:subFuntionNode];
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
    
    if (mID == trackID || mID == -1) NSLog(@"Clear %d", mID);
    
    [self.avatarNode clearContents];
    [self clearLayerContentOfLayer:self.avatarNode.layer];
    
    [self.topTextNode clearContents];
    [self clearLayerContentOfLayer:self.topTextNode.layer];
    
    [self.bottomTextNode clearContents];
    [self clearLayerContentOfLayer:self.bottomTextNode.layer];
    
    [self.subFuntionNode clearContents];
    [self clearLayerContentOfLayer:self.subFuntionNode.layer];
    
    if (self.messageBackgroundNode) {
        [self.messageBackgroundNode clearContents];
        [self clearLayerContentOfLayer:self.messageBackgroundNode.layer];
    }
    
    [self clearLayerContentOfLayer:self.layer];
}

- (void)clearLayerContentOfLayer:(CALayer *)layer {
    for (CALayer * sub in layer.sublayers) {
        [self clearLayerContentOfLayer:sub];
    }
    layer.contents = nil;
}

- (void)dealloc {
//    NSLog(@"Dealloc %d", mID);
}

@end
