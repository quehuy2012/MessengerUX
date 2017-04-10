/* Copyright (c) 2015-present, Zalo Group.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface UXImageAttachment : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat descent;
@property (nonatomic, readonly) CTRunDelegateCallbacks callbacks;
@end
