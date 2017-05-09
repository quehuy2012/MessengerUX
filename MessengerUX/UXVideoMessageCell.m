//
//  UXVideoMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 4/10/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell+Private.h"
#import "UXVideoMessageCell.h"
#import "UXMessageCellConfigure.h"
#import "UXMessageBackgroundStyle.h"
#import "UXVideoMessage.h"

@interface UXVideoMessageCell () <ASVideoPlayerNodeDelegate>

@property (nonatomic) ASVideoPlayerNode * videoNode;
@property (nonatomic) ASButtonNode * muteVideoButton;
@property (nonatomic) NSUInteger videoPadding;

@end

@implementation UXVideoMessageCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.videoPadding = 4;
        
        [self initView];
    }
    
    return self;
}

- (void)initView {
    
    if (self.viewRemoved) {
        [super initView];
        
        if (!self.firstInited) {
            [self addViewWithModel:self.model];
        }
        
        self.viewRemoved = NO;
    }
}

- (void)clearView {
    
    if (!self.viewRemoved) {
        [super clearView];
        
        
        [self.videoNode removeFromSupernode];
        
        [self.videoNode clearContents];
        [self clearLayerContentOfLayer:self.videoNode.layer];
        
        self.videoNode = nil;
        
        [self.muteVideoButton removeFromSupernode];
        
        [self.muteVideoButton removeTarget:self action:@selector(muteButtonClicked) forControlEvents:ASControlNodeEventTouchUpInside];
        
        [self.muteVideoButton clearContents];
        [self clearLayerContentOfLayer:self.muteVideoButton.layer];
        
        self.muteVideoButton = nil;
        
        self.viewRemoved = YES;
    }
}

- (void)updateUI:(id)model {
    if (model && !self.viewRemoved) {
        [super updateUI:model];
        
        if (self.firstInited) {
            [self addViewWithModel:model];
        }
    }
}

- (void)addViewWithModel:(id)model {
    if ([model isKindOfClass:[UXVideoMessage class]]) {
        UXVideoMessage * videoMessage = model;
        
        self.videoNode = [[ASVideoPlayerNode alloc] initWithURL:videoMessage.videoURL];
        self.videoNode.delegate = self;
        self.videoNode.backgroundColor = [UIColor blackColor];
        self.videoNode.style.width = ASDimensionMakeWithPoints([UXMessageCellConfigure getGlobalConfigure].maxWidthOfCell);
        self.videoNode.style.height = ASDimensionMakeWithPoints((CGFloat)([UXMessageCellConfigure getGlobalConfigure].maxWidthOfCell) * videoMessage.ratio);
        self.videoNode.cornerRadius = [[UXMessageCellConfigure getGlobalConfigure] getMessageBackgroundStyle].cornerRadius - self.videoPadding;
        self.videoNode.clipsToBounds = YES;
        
        [self addSubnode:self.videoNode];
        
        self.muteVideoButton = [[ASButtonNode alloc] init];
        self.muteVideoButton.style.width = ASDimensionMakeWithPoints(26.0);
        self.muteVideoButton.style.height = ASDimensionMakeWithPoints(26.0);
        
        //        self.muteVideoButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
        //        self.muteVideoButton.contentMode = UIViewContentModeScaleAspectFill;
        
        //        self.muteVideoButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        //        self.muteVideoButton.cornerRadius = 13;
        
        [self.muteVideoButton addTarget:self action:@selector(muteButtonClicked) forControlEvents:ASControlNodeEventTouchUpInside];
        
        //[self addSubnode:self.muteVideo∂∂ΩΩButton];
        
        [self setupMuteButtonUI];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    if (self.viewRemoved) {
        if (self.tempHolder == nil) {
            self.tempHolder = [[ASDisplayNode alloc] init];
        }
        self.tempHolder.style.width = ASDimensionMake(self.calculatedSize.width);
        self.tempHolder.style.height = ASDimensionMake(self.calculatedSize.height);
        return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                       spacing:0
                                                justifyContent:ASStackLayoutJustifyContentStart
                                                    alignItems:ASStackLayoutAlignItemsEnd
                                                      children:@[self.tempHolder]];
    } else {
        
//        self.tempHolder = nil;
        
        ASInsetLayoutSpec * imageInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.videoPadding, self.videoPadding, self.videoPadding, self.videoPadding)
                                               child:self.videoNode];
        
        ASBackgroundLayoutSpec * imageWithBackground =
        [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:imageInset background:self.messageBackgroundNode];
        
        NSArray * mainChild = nil;
        if (self.showSubFunction) {
            if (self.isIncomming) {
                mainChild = @[imageWithBackground, self.subFuntionNode];
            } else {
                mainChild = @[self.subFuntionNode, imageWithBackground];
            }
        } else {
            mainChild = @[imageWithBackground];
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
            [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, [UXMessageCellConfigure getGlobalConfigure].insets.left*2, 0, [UXMessageCellConfigure getGlobalConfigure].insets.right*2)
                                                   child:self.topTextNode];
            [stackedMessageChilds addObject:topTextInset];
        }
        
        [stackedMessageChilds addObject:mainWithSubFunctionStack];
        
        if (self.showTextAsBottom) {
            ASInsetLayoutSpec * bottomTextInset =
            [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, [UXMessageCellConfigure getGlobalConfigure].insets.left*2, 0, [UXMessageCellConfigure getGlobalConfigure].insets.right*2)
                                                   child:self.bottomTextNode];
            [stackedMessageChilds addObject:bottomTextInset];
        }
        
        ASStackLayoutAlignItems supportAlignItem = ASStackLayoutAlignItemsStart;
        if (!self.isIncomming) {
            supportAlignItem = ASStackLayoutAlignItemsEnd;
        }
        
        ASStackLayoutSpec * stackedMessage =
        [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                spacing:4
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
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:[UXMessageCellConfigure getGlobalConfigure].insets child:mainContent];
    }
}

- (void)setupMuteButtonUI {
    if (self.videoNode.muted) {
        [self.muteVideoButton setImage:[UIImage imageNamed:@"unmuteButton"] forState:UIControlStateNormal];
    } else {
        [self.muteVideoButton setImage:[UIImage imageNamed:@"muteButton"] forState:UIControlStateNormal];
    }
}

- (void)muteButtonClicked {
    self.videoNode.muted = !self.videoNode.muted;
    [self setupMuteButtonUI];
}

#pragma mark - ASVideoPlayerNodeDelegate

- (void)didTapVideoPlayerNode:(ASVideoPlayerNode *)videoPlayer
{
    if (self.videoNode.playerState == ASVideoNodePlayerStatePlaying) {
        [self.videoNode pause];
    } else {
        [self.videoNode play];
    }
}

- (NSDictionary *)videoPlayerNodeCustomControls:(ASVideoPlayerNode *)videoPlayer
{
    return @{
             @"muteControl" : self.muteVideoButton
             };
}

- (NSArray *)controlsForControlBar:(NSDictionary *)availableControls
{
    NSMutableArray *controls = [[NSMutableArray alloc] init];
    
    if (availableControls[ @(ASVideoPlayerNodeControlTypePlaybackButton) ]) {
        [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypePlaybackButton) ]];
    }
    
    if (availableControls[ @(ASVideoPlayerNodeControlTypeElapsedText) ]) {
        [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypeElapsedText) ]];
    }
    
    if (availableControls[ @(ASVideoPlayerNodeControlTypeScrubber) ]) {
        [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypeScrubber) ]];
    }
    
    if (availableControls[ @(ASVideoPlayerNodeControlTypeDurationText) ]) {
        [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypeDurationText) ]];
    }
    
    return controls;
}

- (ASLayoutSpec*)videoPlayerNodeLayoutSpec:(ASVideoPlayerNode *)videoPlayer forControls:(NSDictionary *)controls forMaximumSize:(CGSize)maxSize
{
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.style.flexGrow = 1.0;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10.0, 10.0, 0.0, 10.0);
    
    if (controls[ @(ASVideoPlayerNodeControlTypeScrubber) ]) {
        ASDisplayNode *scrubber = controls[ @(ASVideoPlayerNodeControlTypeScrubber) ];
        scrubber.style.height = ASDimensionMakeWithPoints(44.0);
        scrubber.style.minWidth = ASDimensionMakeWithPoints(0.0);
        scrubber.style.maxWidth = ASDimensionMakeWithPoints(maxSize.width);
        scrubber.style.flexGrow = 1.0;
    }
    
    NSArray *controlBarControls = [self controlsForControlBar:controls];
    NSMutableArray *topBarControls = [[NSMutableArray alloc] init];
    
    //Our custom control
    if (controls[@"muteControl"]) {
        [topBarControls addObject:controls[@"muteControl"]];
    }
    
    
    ASStackLayoutSpec *topBarSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                            spacing:10.0
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsCenter
                                                                           children:topBarControls];
    
    ASInsetLayoutSpec *topBarInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:topBarSpec];
    
    ASStackLayoutSpec *controlbarSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                spacing:10.0
                                                                         justifyContent:ASStackLayoutJustifyContentStart
                                                                             alignItems:ASStackLayoutAlignItemsCenter
                                                                               children: controlBarControls ];
    controlbarSpec.style.alignSelf = ASStackLayoutAlignSelfStretch;
    
    
    
    ASInsetLayoutSpec *controlbarInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:controlbarSpec];
    
    controlbarInsetSpec.style.alignSelf = ASStackLayoutAlignSelfStretch;
    
    ASStackLayoutSpec *mainVerticalStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                   spacing:0.0
                                                                            justifyContent:ASStackLayoutJustifyContentStart
                                                                                alignItems:ASStackLayoutAlignItemsStart
                                                                                  children:@[topBarInsetSpec, spacer, controlbarInsetSpec]];
    
    return mainVerticalStack;
    
}

#pragma mark - Memory

- (void)clearContents {
    [super clearContents];
    
    [self.videoNode clearContents];
    [self clearLayerContentOfLayer:self.videoNode.layer];
    
    [self.videoNode.videoNode clearContents];
    [self clearLayerContentOfLayer:self.videoNode.videoNode.layer];
    
    [self.muteVideoButton clearContents];
    [self clearLayerContentOfLayer:self.muteVideoButton.layer];
}

- (void)dealloc {
//    [self clearContents];
    [self clearView];
}

@end
