//
//  UXAttributedTextMessage.h
//  MessengerUX
//
//  Created by CPU11808 on 4/10/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessage.h"

@interface UXAttributedTextMessage : UXMessage

@property(nonatomic) NSString *content;

- (instancetype)initWithContent:(NSString *)string date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

@end
