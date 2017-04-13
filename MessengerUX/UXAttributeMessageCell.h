//
//  UXAttributeMessageCell.h
//  MessengerUX
//
//  Created by CPU11815 on 4/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCell.h"
#import "UXTextMessageCell.h"

@interface UXAttributeMessageCell : UXMessageCell

@property (nonatomic, weak) id<UXTextMessageCellDelegate> delegate;

@end
