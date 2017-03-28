//
//  UXMessageCell.h
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class UXMessageCellConfigure;
@class UXSpeaker;
@protocol UXMessageCellDelegate;

@interface UXMessageCell : ASCellNode

@property (nonatomic) BOOL isIncomming;
@property (nonatomic) BOOL showTextAsTop;
@property (nonatomic) BOOL showTextAsBottom;
@property (nonatomic) BOOL showSubFunction;
@property (nonatomic) UXSpeaker * owner;
@property (nonatomic) UXMessageCellConfigure * configure;

@property (nonatomic) ASTextNode * topTextNode;
@property (nonatomic) ASTextNode * bottomTextNode;
@property (nonatomic) ASImageNode * avatarNode;
@property (nonatomic) ASImageNode * subFuntionNode;
@property (nonatomic) ASDisplayNode * messageBackgroundNode;

@property (nonatomic, weak) id<UXMessageCellDelegate> delegate;

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner;

- (void)setTopText:(NSString *)string;

- (void)setBottomText:(NSString *)string;

@end

@protocol UXMessageCellDelegate <NSObject>

@optional

- (void)messageCell:(UXMessageCell *)messageCell avatarClicked:(ASImageNode *)avatarNode;

- (void)messageCell:(UXMessageCell *)messageCell supportLabelClicked:(ASTextNode *)supportLabel isTopLabel:(BOOL)topLabel;

- (void)messageCell:(UXMessageCell *)messageCell subFunctionClicked:(ASImageNode *)subFunctionNode;

@end
