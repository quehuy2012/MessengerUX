//
//  UXMessageCellConfigure.h
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "AsyncDisplayKit/AsyncDisplayKit.h"

@class UXMessageBackgroundStyle;

@interface UXMessageCellConfigure : NSObject

@property (nonatomic) UIColor * incommingColor;
@property (nonatomic) UIColor * outgoingColor;
@property (nonatomic) UIColor * incommingTextColor;
@property (nonatomic) UIColor * outgoingTextColor;
@property (nonatomic) UIColor * supportTextColor;

@property (nonatomic) NSUInteger supportTextSize;
@property (nonatomic) NSUInteger contentTextSize;


@property (nonatomic) UIEdgeInsets insets;

- (UXMessageBackgroundStyle *)getMessageBackgroundStyle;

@end
