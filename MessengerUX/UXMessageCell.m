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
    BOOL firstInit;
    BOOL viewRemoved;
}

@property (nonatomic) id model;

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
        
        self.isIncomming = NO;
        
        viewRemoved = YES;
        
        [self initView];
        
        firstInit = YES;
    }
    
    return self;
}

- (void)initView {
    
    if (viewRemoved) {
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
        
        viewRemoved = NO;
    }
}

- (void)clearView {
    
    if (!viewRemoved) {
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
        
        viewRemoved = YES;
    }
}

- (void)updateUI {
    if (self.model && !viewRemoved) {
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
    
    [self updateUI];
    
    [super didEnterPreloadState];
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    // parent do thing like setup general info
    if ([object isKindOfClass:[UXMessage class]]) {
        self.model = object;
        [self updateUI];
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
    _topTextNode.hidden = !flagShowTextAsTop;
    [self setNeedsLayout];
}

- (void)setShowTextAsBottom:(BOOL)flagShowTextAsBottom {
    _showTextAsBottom = flagShowTextAsBottom;
    _bottomTextNode.hidden = !flagShowTextAsBottom;
    [self setNeedsLayout];
}

- (void)setShowSubFunction:(BOOL)flagShowSubFunction {
    _showSubFunction = flagShowSubFunction;
    _subFuntionNode.hidden = !flagShowSubFunction;
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
    NSLog(@"Clear %d", mID);
    
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
    
    // remove all child view
    [self clearView];
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
