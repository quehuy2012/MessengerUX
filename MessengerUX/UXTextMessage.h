//
//  Sentence.h
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXMessage.h"

@interface UXTextMessage: UXMessage

@property (nonatomic) NSString * content;

- (instancetype)initWithSententFromString:(NSString *)string;

- (instancetype)initWithContent:(NSString *)string date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

@end
