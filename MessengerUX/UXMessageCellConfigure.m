//
//  UXMessageCellConfigure.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCellConfigure.h"
#import "UXRoundedBackgroundStyle.h"

static UXMessageCellConfigure * globalConfigure;

@implementation UXMessageCellConfigure

+ (UXMessageCellConfigure *)getGlobalConfigure {
    if (globalConfigure) {
        return globalConfigure;
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            globalConfigure = [[UXMessageCellConfigure alloc] init];
        });
        return globalConfigure;
    }
}

+ (void)setGlobalConfigure:(UXMessageCellConfigure *)configure {
    globalConfigure = configure;
}

- (UIColor *)incommingColor {
    return [UIColor colorWithRed:1.0/255.0 green:147.0/255.0 blue:238.0/255.0 alpha:1.0];
}

- (UIColor *)incommingTextColor {
    return [UIColor whiteColor];
}

- (UIColor *)outgoingColor {
    return [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
}

- (UIColor *)outgoingTextColor {
    return [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
}

- (NSUInteger)contentTextSize {
    return 16;
}

- (UIEdgeInsets)insets {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (UIColor *)supportTextColor {
    return [UIColor lightGrayColor];
}

- (UIColor *)highlightBackgroundColor {
    return [UIColor grayColor];
}

- (NSUInteger)supportTextSize {
    return 12;
}

- (NSUInteger)maxWidthOfCell {
    return 240;
}

- (UXMessageBackgroundStyle *)getMessageBackgroundStyle {
    return [[UXRoundedBackgroundStyle alloc] init];;
}

@end
