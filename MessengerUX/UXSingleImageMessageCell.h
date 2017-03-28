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

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImage:(UIImage *)image;

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImageURL:(NSURL *)imageURL ratio:(CGFloat)ratio;

@end
