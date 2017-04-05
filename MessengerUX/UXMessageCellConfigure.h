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

@property (nonatomic, readonly) UIColor * incommingColor;
@property (nonatomic, readonly) UIColor * outgoingColor;
@property (nonatomic, readonly) UIColor * incommingTextColor;
@property (nonatomic, readonly) UIColor * outgoingTextColor;
@property (nonatomic, readonly) UIColor * supportTextColor;
@property (nonatomic, readonly) UIColor * highlightBackgroundColor;

@property (nonatomic, readonly) NSUInteger supportTextSize;
@property (nonatomic, readonly) NSUInteger contentTextSize;
@property (nonatomic, readonly) NSUInteger maxWidthOfCell;

@property (nonatomic, readonly) UIEdgeInsets insets;

+ (UXMessageCellConfigure *)getGlobalConfigure;

+ (void)setGlobalConfigure:(UXMessageCellConfigure *)configure;

- (UXMessageBackgroundStyle *)getMessageBackgroundStyle;

@end
