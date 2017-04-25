//
//  UXAlbumMessageCell.h
//  MessengerUX
//
//  Created by CPU11815 on 3/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell.h"

@protocol UXAlbumMessageCellDelegate <NSObject, UXMessageCellDelegate>

@optional

- (void)messageCell:(UXMessageCell *)messageCell albumImageClicked:(ASControlNode *)imageNode;

@end

@interface UXAlbumMessageCell : UXMessageCell

@property (nonatomic, readonly) BOOL imageUsingURL;
@property (nonatomic, weak) id<UXAlbumMessageCellDelegate> delegate;

@end
