//
//  UXTextMessageCell.h
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell.h"

@protocol UXTextMessageCellDelegate <NSObject, UXMessageCellDelegate>

@optional

- (void)messageCell:(UXMessageCell *)messageCell messageClicked:(ASTextNode *)messageNode;

@end

@interface UXTextMessageCell : UXMessageCell

@property (nonatomic, weak) id<UXTextMessageCellDelegate> delegate;

//- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentText:(NSString *)string;

@end


