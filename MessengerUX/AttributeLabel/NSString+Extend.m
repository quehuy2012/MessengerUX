/* Copyright (c) 2015-present, Zalo Group.
 * All rights reserved.
 */

#import "NSString+Extend.h"

@implementation NSString(Extend)

+ (NSString *)stringWithFormatNumber:(NSInteger)number{
    return [NSString stringWithFormat:@"%ld",(long)number];
}

- (NSString*)trimStringSpaces {
    
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return str;
}

@end
