//
//  UXMinimalistCellConfigue.m
//  MessengerUX
//
//  Created by CPU11815 on 4/11/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMinimalistCellConfigue.h"
#import "UXRoundedShadowBackgroundStyle.h"

@implementation UXMinimalistCellConfigue

- (UIColor *)incommingColor {
    return [UIColor colorWithWhite:1 alpha:1];
}

- (UIColor *)incommingTextColor {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

- (UIColor *)outgoingColor {
    return [UIColor colorWithWhite:1 alpha:1];
}

- (UIColor *)outgoingTextColor {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

- (NSUInteger)contentTextSize {
    return 16;
}

- (UIEdgeInsets)insets {
    return UIEdgeInsetsMake(12, 12, 12, 12);
}

- (UXMessageBackgroundStyle *)getMessageBackgroundStyle {
    return [[UXRoundedShadowBackgroundStyle alloc] init];
}

@end
