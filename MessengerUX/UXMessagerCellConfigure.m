//
//  UXMessagerCellConfigure.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessagerCellConfigure.h"
#import "UXRoundedBackgroundStyle.h"

@implementation UXMessagerCellConfigure

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

- (UXMessageBackgroundStyle *)getMessageBackgroundStyle {
    return [[UXRoundedBackgroundStyle alloc] init];
}

@end
