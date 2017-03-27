//
//  UXIMessageCellConfigure.m
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXIMessageCellConfigure.h"
#import "UXRoundedBackgroundStyle.h"

@implementation UXIMessageCellConfigure

- (UIColor *)incommingColor {
    return [UIColor colorWithRed:0/255.0 green:214.0/255.0 blue:102.0/255.0 alpha:1.0];
}

- (UIColor *)incommingTextColor {
    return [UIColor whiteColor];
}

- (UIColor *)outgoingColor {
    return [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:235.0/255.0 alpha:1.0];
}

- (UIColor *)outgoingTextColor {
    return [UIColor blackColor];;
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
