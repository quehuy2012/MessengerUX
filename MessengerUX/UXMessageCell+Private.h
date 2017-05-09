//
//  UXMessageCell+Private.h
//  MessengerUX
//
//  Created by CPU11815 on 5/8/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#ifndef UXMessageCell_Private_h
#define UXMessageCell_Private_h

#import "UXMessageCell.h"

@interface UXMessageCell ()

@property (nonatomic) UXOwner * owner;

@property (nonatomic) ASTextNode * topTextNode;
@property (nonatomic) ASTextNode * bottomTextNode;
@property (nonatomic) ASImageNode * avatarNode;
@property (nonatomic) ASImageNode * subFuntionNode;
@property (nonatomic) ASControlNode * messageBackgroundNode;
@property (nonatomic) ASDisplayNode * tempHolder;

@property (nonatomic) id model;

@property (nonatomic) BOOL viewRemoved;
@property (nonatomic) BOOL firstInited;

- (void)clearLayerContentOfLayer:(CALayer *)layer;

- (void)initView;

- (void)clearView;

- (void)updateUI:(id)model;

@end

#endif /* UXMessageCell_Private_h */
