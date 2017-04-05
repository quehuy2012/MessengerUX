//
//  UXSingleImageMessageCell.h
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell.h"

@protocol UXSingleImageMessageCellDelegate <NSObject, UXMessageCellDelegate>

@optional

- (void)messageCell:(UXMessageCell *)messageCell imageClicked:(ASControlNode *)imageNode;

@end

@interface UXSingleImageMessageCell : UXMessageCell

@property (nonatomic, weak) id<UXSingleImageMessageCellDelegate> delegate;

@end
