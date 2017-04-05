//
//  UXTitleMessageCell.h
//  MessengerUX
//
//  Created by CPU11815 on 3/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell.h"

@protocol UXTitleMessageCellDelegate <NSObject, UXMessageCellDelegate>

@optional

- (void)messageCell:(UXMessageCell *)messageCell titleClicked:(ASTextNode *)titleNode;

@end

@interface UXTitleMessageCell : UXMessageCell

@property (nonatomic, weak) id <UXTitleMessageCellDelegate> delegate;

@end
