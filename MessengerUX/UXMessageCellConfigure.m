//
//  UXMessageCellConfigure.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCellConfigure.h"

@implementation UXMessageCellConfigure

- (UIColor *)incommingColor {
    NSAssert(NO, @"Must overide this method");
    return nil;
}

- (UIColor *)outgoingColor {
    NSAssert(NO, @"Must overide this method");
    return nil;
}

- (UIColor *)incommingTextColor {
    NSAssert(NO, @"Must overide this method");
    return nil;
}

- (UIColor *)outgoingTextColor {
    NSAssert(NO, @"Must overide this method");
    return nil;
}

- (UIColor *)supportTextColor {
    return [UIColor lightTextColor];
}

- (NSUInteger)supportTextSize {
    return 12;
}

- (NSUInteger)contentTextSize {
    NSAssert(NO, @"Must overide this method");
    return 0;
}

- (UIEdgeInsets)insets {
    NSAssert(NO, @"Must overide this method");
    return UIEdgeInsetsZero;
}

- (UXMessageBackgroundStyle *)getMessageBackgroundStyle {
    NSAssert(NO, @"Must overide this method");
    return nil;
}

@end
