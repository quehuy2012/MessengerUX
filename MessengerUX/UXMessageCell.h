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

@interface UXMessageCell : ASCellNode

@property (nonatomic) BOOL isIncomming;
@property (nonatomic) UXSpeaker * owner;
@property (nonatomic) UXMessageCellConfigure * configure;

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner;

- (void)setTopText:(NSString *)string;

- (void)setBottomText:(NSString *)string;

- (void)showTopText:(BOOL)flag;

- (void)showBottomText:(BOOL)flag;

@end
