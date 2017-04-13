//
//  UXAttributeMessage.h
//  MessengerUX
//
//  Created by CPU11815 on 4/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessage.h"

@interface UXAttributeMessage : UXMessage

@property (nonatomic) NSString * content;

- (instancetype)initWithSententFromString:(NSString *)string;

- (instancetype)initWithContent:(NSString *)string date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

@end
